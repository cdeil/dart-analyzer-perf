# Draft issue: analysis_server_plugin enables fine-grained dependencies unconditionally

Status: DRAFT, not filed. Component: `analysis_server_plugin`, `analysis_server`.

## Title

[analysis_server_plugin] Plugin context collection uses `withFineDependencies: true` while the host runs with fine dependencies off

## Body

`PluginServer._createContextCollection` (pkg/analysis_server_plugin/lib/src/plugin_server.dart)
creates its `AnalysisContextCollectionImpl` with `withFineDependencies: true`. The analysis
server that hosts the plugin only enables fine dependencies when started with
`--with-fine-dependencies`, which `dart analyze` and the IDEs do not pass by default.

In the plugin's fresh-process CLI case the byte store is memory-only, so the fine-dependency
machinery (library manifests computed for every linked cycle, requirement recording during
linking and resolution, diagnostics bundles with requirements) never pays for itself: nothing
survives the process.

Measured with the analyzer's `OperationPerformance` tree, driving `PluginServer` in-process
(scripts and fixture: https://github.com/cdeil/dart-analyzer-perf):

| Workspace | Fine dependencies on | Off | Bytes written to the store |
| --- | --- | --- | --- |
| Public fixture, 3,201-file closure, cold | 5.1 to 5.6 s | 3.8 to 3.9 s | — |
| Private Flutter workspace, 7,481-file closure, cold | 12.5 to 15.7 s | 9.4 to 10.1 s | 143 MB vs 62 MB |
| Same, with a persistent `FileByteStore`, warm | 3.0 to 3.8 s | 2.0 to 2.5 s | |

`computeManifests` alone is 2.6 s on the private workspace; the rest is requirement
recording inside `link` and `LibraryAnalyzer`, and in the warm case 256 to 422
requirement-check misses that trigger re-analysis of libraries whose cached diagnostics would
otherwise be reused.

Proposal: let the host tell the plugin which mode it runs in, so the plugin mirrors the host.
The smallest change is an optional `withFineDependencies` field on `plugin.versionCheck`
(defaulting to false, the host's default), passed from `PluginIsolate.start` and used in
`_createContextCollection`. Older hosts that omit the field get the host default. Fine
dependencies stay available for IDE sessions that opt in.

Related: #64202 (persistent store for plugins), #63292.
