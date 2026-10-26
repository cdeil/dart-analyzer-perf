# Draft comment for dart-lang/sdk#64202 (persistent ByteStore in analyzer plugins)

Status: DRAFT, not posted. To be reviewed and edited by the author before posting; every
number below comes from `results/` in this repository or from the private-app review
summarised in `notes/`. Keep it short when posting; the issue thread is read by the people
who would review a patch.

---

I measured where `dart analyze` spends its time with a native plugin enabled, on a public
synthetic Flutter + Riverpod workspace (666 files, 3,201-file closure; generator and
scripts in https://github.com/cdeil/dart-analyzer-perf) and on a private Flutter workspace
(736 libraries, 7,481-file closure). Apple M5 Pro, Flutter 3.47.8 / Dart 3.13.7,
`riverpod_lint` 3.1.9 → `analysis_server_plugin` 0.3.25, `analyzer` 14.6.0.

**The plugin isolate costs what a cold analyzer costs.** On the private workspace,
`dart analyze --no-plugins` with an emptied `.analysis-driver` takes 18 to 19.5 s; the
full run with the plugin takes 15 s; with the host warm and no plugin, 2.4 s. The plugin's
`MemoryCachingByteStore(NullByteStore(), 256 MiB)` means every CLI run relinks the whole
closure. Driving `PluginServer` in-process with the analyzer's own `OperationPerformance`
tree gives, for the private workspace (plugin isolate only, cold):

| Phase | Time |
| --- | --- |
| `fileState.refresh` (read, MD5, parse, unlinked) for 6,697 files | 4.3 s |
| `link` for 3,359 library cycles | 5.4 s |
| `computeManifests` (fine dependencies) | 2.6 s |
| `analyzeFile`, produceErrors pass | 1.1 s |
| `analyzeFile`, second pass from `getResolvedLibrary` | 1.0 s |
| plugin rules | 0.1 s |

**Backing the same cache with `FileByteStore` makes the plugin side 3 to 4× cheaper on
repeated runs**, with identical diagnostics: private workspace 12.5 to 15.7 s → 3.0 to
3.8 s to idle; public fixture 5.1 to 5.6 s → 2.1 to 2.3 s. That is the change proposed in
CL 543560, so I would like to help move it forward. Two observations from the same
measurements seem worth folding in or filing separately:

1. `PluginServer` creates its context collection with `withFineDependencies: true`, while
   `dart analyze`'s server runs with fine dependencies off. In a fresh process with a
   non-persistent store the manifests and requirement recording are pure overhead:
   turning them off saves 2.6 s cold and about 1 s warm on the private workspace (1.2 s
   cold on the fixture), and halves the bytes written to the store (62 MB vs 143 MB).
   Mirroring the host's setting (an optional field in `plugin.versionCheck`) would keep
   the IDE behaviour and remove the cost from the CLI.
2. Every library is resolved twice: the driver's `produceErrors` pass emits a
   `ResolvedUnitResult`, then `_handleResolvedUnit` calls `getResolvedLibrary`, which
   re-analyzes because only priority files are cached (`_resolvedLibraryCache`). The
   second pass costs about 1 s per run here; a small bounded cache of recent resolved
   libraries in the driver would remove it.

I ported the change to current main on a branch (plain `FileByteStore` as the
`EvictingFileByteStore` documentation prescribes for plugins, a guard for non-physical
resource providers, a flush before the `plugin.shutdown` response, and behavioral tests
that start two plugin servers on one store directory). With it, plus the two observations
above applied, the public fixture's plugin isolate goes from 4.4 to 4.7 s per run to
3.7 s on the first run and 1.1 to 1.2 s afterwards, with identical diagnostics
(https://github.com/cdeil/dart-analyzer-perf/blob/main/patches/README.md).

On the CL itself, from reading PS1: the suffix only affects temporary writer file names,
so host and plugin would share permanent entries in `.analysis-driver`, but with the
stable SDK's analyzer at `DATA_VERSION` 644 and the plugin's at 747 no key is ever shared
in practice; the shared directory mostly matters for eviction accounting, which is the
open question from this thread. The `EvictingFileByteStore` documentation already says
plugins should use a plain `FileByteStore` and leave eviction to the server, and the
server's start-up scan plus its write-triggered scans do bound the directory (plugin
writes correlate with host writes, since both analyze the same changes); the port keeps
that design. If an independent budget is preferred, a plugin-owned subdirectory with its
own `EvictingFileByteStore` is a small variation. I can upload the port if that is useful.
