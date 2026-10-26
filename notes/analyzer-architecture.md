# How `dart analyze` runs a native analyzer plugin

Notes written while measuring `dart analyze --fatal-infos` on Flutter workspaces with
`riverpod_lint` enabled. File references are to the Dart SDK repository (`pkg/...`) at
`main` in late October 2026; the published packages `analyzer` 14.6.0 and
`analysis_server_plugin` 0.3.25 are cut from the same tree. Dart 3.13.7 stable embeds an
older analyzer (pubspec version 14.1.0-dev) in its analysis server.

## 1. Process and isolate topology

```
dart analyze                      pkg/dartdev/lib/src/commands/analyze.dart
  └─ analysis server process      pkg/dartdev/lib/src/analysis_server.dart (Process.start)
       │  dartaotruntime analysis_server_aot.dart.snapshot --protocol=analyzer ...
       ├─ host isolate group       pkg/analysis_server/lib/src/analysis_server.dart
       │     AnalysisContextCollection, one AnalysisDriver per context root
       │     byte store: MemoryCachingByteStore(EvictingFileByteStore(~/.dartServer/.analysis-driver, 4 GiB), 256 MiB)
       └─ plugin isolate group     Isolate.spawnUri(plugin.aot)   pkg/analysis_server/lib/src/plugin/server_isolate_channel.dart
             PluginServer          pkg/analysis_server_plugin/lib/src/plugin_server.dart
             its own AnalysisContextCollection, FileContentCache and driver
             byte store: MemoryCachingByteStore(NullByteStore(), 256 MiB)   <- nothing persists
```

The CLI front end (`dartdev`) sends `analysis.setAnalysisRoots` and waits for
`server.status` to report `isAnalyzing: false`. The host's status includes the plugin's
status (`PluginManager` forwards `plugin.status`), which is why `dart analyze` waits for
plugin diagnostics while `flutter analyze` (LSP-driven in Flutter 3.47) does not
(flutter/flutter#187999).

Host and plugin are separate isolate groups in one OS process: separate heaps, separate
analyzer object graphs, two threads of work. Nothing but bytes can be shared, and even
bytes are not shared in practice because every cache key is salted with
`AnalysisDriver.DATA_VERSION` (`pkg/analyzer/lib/src/dart/analysis/driver.dart`), which is
644 in the 3.13.7 host and 747 in analyzer 14.6.0.

## 2. Plugin startup

`pkg/analysis_server/lib/src/plugin/plugin_manager.dart` and `plugin2/generator.dart`:

1. The host reads the `plugins:` section of the root `analysis_options.yaml` and
   generates a synthetic package `plugin_entrypoint` with a `pubspec.yaml` that depends on
   `analysis_server_plugin` and each plugin package, plus `bin/plugin.dart` that constructs
   `PluginServer.new2(plugins: {...})` and starts a `PluginIsolateChannel`.
2. The package lives in `~/.dartServer/.plugin_manager/<md5 of the consumer path>/`.
   Because the key is the consuming path, every checkout or git worktree gets its own
   copy and its own AOT compile (SDK issue 63244).
3. `dart pub get` runs for the synthetic package (network on first use), then
   `dart compile aot-snapshot bin/plugin.dart` (12 to 30 s). The snapshot is reused when
   its depfile entries are older than the snapshot.
4. The host spawns the snapshot with `Isolate.spawnUri`, sends `plugin.versionCheck`
   (byte store path, SDK path, protocol version), then `analysis.setAnalysisRoots` (the
   client's roots) and `analysis.setContextRoots`. Since analysis_server_plugin 0.3.20 the
   plugin prefers the analysis roots; CL 548020 (Sep 2026) narrows them to the plugin's
   context roots on the host side.

## 3. What the plugin server does with a root

`PluginServer._createContextCollection` creates an `AnalysisContextCollectionImpl` with
`withFineDependencies: true`, `drainStreams: false`, a fresh `FileContentCache`, and
analysis options with warnings and lints disabled (the host reports those). It then
listens to the driver scheduler's event stream and calls `driver.addFile` for every
analyzed Dart file in the context root (`_analyzeAllFilesInContextCollection`).

From there the analyzer driver's own loop does the work:

```
AnalysisDriverScheduler._run            driver.dart (one driver chunk at a time)
  AnalysisDriver.performWork
    _produceErrors(path)                 for every added file
      libraryContext.loadForResolution   ensure the library cycle is linked/loaded
      _getLibraryDiagnosticsBundle       fine-deps cache lookup (miss on a fresh process)
      _analyzeFileImpl                   LibraryAnalyzer: parse, resolve, diagnostics
        eventsController.add(ResolvedUnitResult)
```

`PluginServer._handleResolvedUnit` receives the `ResolvedUnitResult`, then calls
`currentSession.getResolvedLibrary(path)`. The driver only caches resolved libraries for
priority files (`_resolvedLibraryCache`, populated when `isLibraryWithPriorityFile`), so
this request schedules a second `_analyzeFileImpl` for the same library. Every library is
therefore resolved twice per run. The plugin rules then run over the library's units via
`_analyzeAndSendDiagnostics` and `_computeDiagnosticsFromPlugin`, with the rule set
selected per file from the nearest `analysis_options.yaml` (`pluginConfigurations`).

The plugin does not cache its own diagnostics anywhere. The analyzer's diagnostics
bundles (`LibraryDiagnosticsBundle`, keyed by content and transitive API signature) are
written to the byte store, but the byte store is memory-only and the rules' output is not
part of them.

## 4. Where the analyzer spends time on a cold run

Measured with the in-process probe on a 7,481-file closure (Flutter app, 736 analyzed
libraries), exclusive times from the driver's `OperationPerformance` tree:

| Phase | Code | Cold | Warm with a file byte store |
| --- | --- | --- | --- |
| `fileState.refresh` for 6,697 files (read, MD5, parse, unlinked summary) | `pkg/analyzer/lib/src/dart/analysis/file_state.dart` | 4.3 s | 0.8 s |
| `link` 3,359 library cycles | `pkg/analyzer/lib/src/summary2/link.dart`, `library_context.dart` | 5.4 s | 0 (bundles read: 0.2 s) |
| `computeManifests` (fine dependencies) | `pkg/analyzer/lib/src/fine/` | 2.6 s | ~1 s of requirement checks and re-analysis |
| `analyzeFile` first pass | `LibraryAnalyzer` | 1.1 s | only on cache misses |
| `analyzeFile` second pass (plugin's `getResolvedLibrary`) | plugin_server.dart | 1.0 s | 1.0 s under full rule coverage |
| plugin rules | riverpod_lint | 0.1 to 0.6 s | same |

The closure is dominated by dependencies: `package:flutter` 693 files / 22 MB, one 14 MB
icon file, `material_ui`, `win32`, `dart:` 202 files / 4 MB. Both isolates read and hash all
of it.

### 4.1 File state

`FileSystemState.getFileForPath` → `FileState.refresh`: reads the file through
`FileContentCache` (MD5 of the bytes becomes `contentHash`), builds the unlinked key
`<salt + feature set + language version + contentHash>.unlinked2`, and loads the unlinked
unit from the byte store or parses the file and serializes it (`serializeAstUnlinked2`,
API signature). Every process reads and hashes every file in the closure; a persistent
`(path, size, mtime) → hash` memo would skip that for unchanged files.

### 4.2 Library cycles and linking

`LibraryFileKind.libraryCycle` computes strongly connected components of the import graph
(`library_graph.dart`). `LibraryContext.load` collects the cycles to load in post-order
and for each either reads a linked bundle (`_probeLinkedBundle` → `BundleReader`) or
links it (`link(...)` → `buildOutlines`, `computeLibraryScopes`, `writeLibraries`). The
linked key is `cycle.linkedKey`, derived from the transitive API signatures and the salt.
Linking is sequential in dependency order inside one isolate.

### 4.3 Fine-grained dependencies

With `withFineDependencies: true` the linker also builds `LibraryManifest`s for every
library (`computeManifests`) and records a `RequirementsManifest` during linking and
resolution (every element access goes through `globalResultRequirements`). Diagnostics
bundles then carry requirements so that an edit only invalidates results that actually
used the changed API. This is an editor optimisation; in a fresh process whose byte store
does not persist it is pure cost. The host runs with fine dependencies off unless started
with `--with-fine-dependencies`.

### 4.4 Byte stores and eviction

`pkg/analyzer/lib/src/dart/analysis/file_byte_store.dart`: `FileByteStore` writes
`<key[0:2]>/<key>` files through a bounded async pool, validated by length and a 16-bit
checksum on read. `EvictingFileByteStore` adds a cleanup isolate that runs at construction
and after every `maxSize/8` bytes written, deleting the least recently *accessed* files
(`FileStat.accessed`) until the directory is under budget (4 GiB by default in the analysis
server); whether a read refreshes that timestamp depends on the file system's atime policy. A
busy IDE on several worktrees and SDK versions keeps the directory at the budget (this
machine: 4.7 GB, 332k files, 220k of them written in the last week), and the startup scan
of such a directory costs the warm host about 2 s per CLI run. `SingleFileByteStore`
(CL 543760, merged) is a paged single-file alternative, not yet wired to the server by
default.

## 5. Levers, by component

| Lever | Component | Status |
| --- | --- | --- |
| Persistent byte store for the plugin | analysis_server_plugin | SDK #64202, CL 543560 (unreviewed PS1) |
| Fine dependencies off unless the host uses them | analysis_server_plugin + analyzer_plugin protocol | not filed |
| Resolve each library once | analyzer driver or analysis_server_plugin | not filed; related CL 543140, #64381 |
| Cache plugin diagnostics with the driver's unit signature | analysis_server_plugin + analyzer | not filed |
| Key plugin builds by content, not consumer path | analysis_server plugin manager | SDK #63244 |
| Skip unchanged files by metadata | analyzer FileContentCache | not filed; related #64065 / CL 538901 (BLAKE3) |
| Single-file byte store for the plugin | analyzer / analysis_server_plugin | CL 543760 merged standalone |
| Skip the startup eviction scan when the last one was recent | analyzer EvictingFileByteStore | not filed |
| Parallel unlinked phase, parallel linking | analyzer | research; CL 559340, 542560 in flight |

## 6. A second public data point: the ROHD reproducer

`bench/rohd_bench.sh` runs the reproducer from dart-lang/sdk#63292 (ROHD v0.6.10, a
123-file pure-Dart package, plus a no-op semantic plugin rule). On this machine with Dart
3.13.7 (`results/rohd/darwin-3.13.7.txt`): native analyzer with its persistent cache 2.0,
1.2, 0.9 s; isolated fresh cache 1.7, 1.3, 0.9 s; no-op plugin 2.0, 2.0, 2.1 s per unchanged
pass after a 22 s bootstrap. The plugin isolate costs about one cold analysis of the
package's small closure (dart: libraries and a few packages) on every run, which is the
same mechanism as on the Flutter workspaces, at a scale where it is 1 s instead of 10 s.
The 18 s the reporter saw on Dart 3.11.6 is gone in 3.13.
