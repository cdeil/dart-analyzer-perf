# Draft issue: analysis_server_plugin resolves every library twice

Status: DRAFT, not filed. Component: `analysis_server_plugin`, `analyzer` driver.

## Title

[analysis_server_plugin] Each library is fully resolved twice per analysis pass

## Body

`PluginServer` adds every analyzed file to its driver and listens to the scheduler's event
stream. For each file the driver's `produceErrors` runs `_analyzeFileImpl` (full
`LibraryAnalyzer` resolution) and emits a `ResolvedUnitResult`. `_handleResolvedUnit` then
calls `analysisContext.currentSession.getResolvedLibrary(path)` to get all units of the
library for the rules. `AnalysisDriver.getResolvedLibrary` only serves from
`_resolvedLibraryCache`, which is populated for libraries containing priority files
(`_isLibraryWithPriorityFile`), so for ordinary files the request schedules a second
`_analyzeFileImpl` of the same library.

Counts from an instrumented run (https://github.com/cdeil/dart-analyzer-perf): 736 libraries,
1,471 `analyzeFile` operations, 1,888 `ResolvedUnitResult` events (2 × 944 units); on the
public fixture 665 libraries, 1,330 events. The second pass costs about 1 s on a 736-library
workspace (`parseAndResolve` 0.7 s + `computeDiagnostics` 0.2 s), cold or warm, whenever the
first pass had to run. With a persistent store and full rule coverage the two passes are the
dominant remaining warm cost (2.0 s of a 4.1 s run).

Proposal: keep a small bounded cache of the most recent `ResolvedLibraryResultImpl`s in
`AnalysisDriver` (not only for priority files), invalidated in the same places as
`_resolvedLibraryCache`, so a `getResolvedLibrary` that immediately follows the event is a
hit. The plugin consumes each event within the next event-loop turn, so a capacity of a few
libraries is enough; memory stays bounded. Alternatively, emit the library result on the
events stream so `PluginServer` never has to ask.

Related: CL 543140 (gating resolution on applicable rules) addresses files that need no
resolution at all; this issue is about files that do.
