# Draft issue: analysis_server_plugin resolves every library twice

Status: FILED 5 November 2026 as https://github.com/dart-lang/sdk/issues/64862 (template "Report an issue
with Dart's static analysis"). Numbers re-checked against `results/`; the code paths
are unchanged on main d0c6cbc8213 (5 November).

## Title

[analysis_server_plugin] Each library is resolved twice per analysis pass

## Body

`PluginServer` adds every analyzed file to its `AnalysisDriver` and listens to the scheduler's events. For each library, the driver resolves it and emits a `ResolvedUnitResult`. `PluginServer._handleResolvedUnit` then calls `currentSession.getResolvedLibrary(path)` to run the rules over all units of the library. `AnalysisDriver.getResolvedLibrary` only answers from `_resolvedLibraryCache` when the library contains a priority file, so for every other library this request resolves the same library a second time.

Counts from an instrumented `PluginServer` (`analysis_server_plugin` 0.3.25, `analyzer` 14.6.0; the code is the same on main):

| Workspace | Libraries | `analyzeFile` per run | `ResolvedUnitResult` events |
| --- | --- | --- | --- |
| Public synthetic Flutter + Riverpod workspace | 665 | 1,330 | 1,330 |
| Private Flutter app | 736 | 1,472 | 1,888 |

The second pass costs about 0.3 s per `dart analyze` on the public workspace and 1 s on the private app, with or without a persistent plugin byte store (#64202). The workspace generator and the instrumentation are in https://github.com/cdeil/dart-analyzer-perf.

A possible fix is a small bounded cache in `AnalysisDriver` of the most recently produced `ResolvedLibraryResult`s for libraries without priority files, cleared wherever `_resolvedLibraryCache` is cleared. With 8 entries the follow-up `getResolvedLibrary` is a hit: 665 instead of 1,330 `analyzeFile` on the public workspace, and the plugin isolate goes from 4.4–4.7 s to 4.1–4.5 s on a cold run (1.55 s to 1.34 s on a warm run with a persistent store), with the same diagnostics. The driver and plugin tests pass with it. Another option would be for the driver to put the `ResolvedLibraryResult` on the events stream. I'm happy to upload a CL for whichever approach you prefer.

```
$ dart --version
Dart SDK version: 3.13.7 (stable) (Thu Oct 22 14:28:57 2026 -0700) on "macos_arm64"
```
