# CL plan

Status: DRAFT. Each entry is one Gerrit change against `main`, uploaded with `git cl upload`
after the CLA is signed. Order matters: later entries build on earlier ones. Dart CL
descriptions are short, name the bug (`Bug: https://github.com/dart-lang/sdk/issues/N`) and
the test that was run (`TEST=`), and never contain generated planning text.

| # | Branch | Change | Bug | Depends on |
| --- | --- | --- | --- | --- |
| 1 | `plugin-byte-store` | `[analysis_server_plugin] Persist the plugin byte store with a FileByteStore` | #64202 (continues CL 543560 PS1, credit its author) | — |
| 2 | `driver-recent-libraries` | `[analyzer] Cache the most recently resolved libraries in AnalysisDriver` | new issue (double resolution) | — |
| 3 | `plugin-fine-dependencies` | `[analysis_server_plugin] Mirror the server's fine-dependency setting in plugins` | new issue (fine dependencies) | protocol regeneration (done on the branch) |
| 4 | `byte-store-scan` | `[analyzer] Skip the start-up cache scan after a recent clean up` | new issue (startup eviction scan) | — |
| 5 | `plugin-build-key` | `[analysis_server] Key plugin builds by their generated pubspec, not by consumer path` | #63244 | — |

## Description templates

The branches in `~/code/oss/dart-sdk/sdk` already carry commit messages in this form
(`git log origin/main..<branch>`); the templates below are kept for reference. The byte
store branch deliberately uses a plain `FileByteStore`, as `EvictingFileByteStore`'s own
documentation prescribes for plugins; the maintainers' question from the issue thread
(who evicts plugin writes) is answered by the server's existing start-up and
write-triggered scans, and the CL description should say so explicitly.

### 1

```
[analysis_server_plugin] Persist the plugin byte store with a FileByteStore

PluginServer backed its 256 MiB memory cache with NullByteStore, so every
plugin isolate relinked the whole library closure in each new process.
Use a FileByteStore in the directory the server passes in
plugin.versionCheck, with a temp-name suffix for same-process writers,
and flush pending writes before answering plugin.shutdown. The server
keeps owning eviction of that directory.

Measured on a 7,481-file Flutter closure: plugin isolate 12.5-15.7 s cold
to 3.0-3.8 s warm, identical diagnostics (details and scripts in
https://github.com/cdeil/dart-analyzer-perf).

Bug: https://github.com/dart-lang/sdk/issues/64202
TEST=pkg/analysis_server_plugin/test/src/plugin_server_test.dart
     pkg/analyzer/test/src/dart/analysis/file_byte_store_test.dart
```

### 2

```
[analyzer] Cache the most recent resolved libraries in AnalysisDriver

getResolvedLibrary only reused results for libraries with priority files,
so a client that reacts to a ResolvedUnitResult event by asking for the
library (analysis_server_plugin does) triggered a second full resolution
of every library. Keep a small LRU of recent ResolvedLibraryResults,
invalidated with _resolvedLibraryCache.

TEST=pkg/analyzer/test/src/dart/analysis/driver_test.dart
```

### 3

```
[analysis_server_plugin] Mirror the host's fine-dependency setting

Adds an optional withFineDependencies field to plugin.versionCheck. The
server passes its own setting; the plugin uses it for its context
collection instead of unconditionally enabling fine dependencies, which
cost 2.6 s per cold dart analyze run on a 7,481-file closure without
persisting anything.

TEST=pkg/analysis_server_plugin/test/src/plugin_server_test.dart
     pkg/analysis_server/test/src/plugin/plugin_isolate_test.dart
```

## Before uploading

- Run `dart format`, the package tests above, and `tools/sdks/dart-sdk/bin/dart pkg/analyzer/tool/...` presubmit checks as described in `pkg/analyzer/doc/implementation/`.
- Reread every description against the diff; remove anything the diff does not do.
- Add reviewers from `OWNERS` (`git cl upload --r-owners`); for these packages that is the analyzer team (Konstantin Shcheglov, Brian Wilkerson, Samuel Rawlins).
