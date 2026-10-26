"""Create a patched copy of `analysis_server_plugin` with environment-controlled probes.

The copy is written to DEST (never into the pub cache). The probes do not change which rules
run or what they report; they only add counters, timing and switches:

  PROBE_BYTE_STORE=<dir>   back the 256 MiB memory cache with a FileByteStore in <dir>
  PROBE_FINE_DEPS=0        create the analysis context with withFineDependencies: false
  PROBE_PRIORITY_ALL=1     mark every analyzed file as a priority file (single resolution)
  PROBE_SKIP_RULES=1       resolve libraries but do not run plugin rules
  PROBE_MEMORY_MIB=<n>     size of the memory cache (default 256)
  PROBE_PACKAGES=1         dump the known-file closure grouped by package at idle

Usage: python3 patch_framework.py --dest DEST [--source PUB_CACHE_PACKAGE_DIR]
"""
import argparse
import shutil
from pathlib import Path

DEFAULT_SOURCE = Path.home() / '.pub-cache/hosted/pub.dev/analysis_server_plugin-0.3.25'


def patch(source: Path, dest: Path, tolerant: bool = False):
    if dest.exists():
        shutil.rmtree(dest)
    shutil.copytree(source, dest, symlinks=False)
    f = dest / 'lib/src/plugin_server.dart'
    s = f.read_text()

    def replace_once(old, new):
        nonlocal s
        if s.count(old) != 1:
            if tolerant:
                print(f'skipped (anchor not found once): {old.strip().splitlines()[0][:70]!r}')
                return
            raise AssertionError(f'expected exactly one match for: {old[:80]!r}')
        s = s.replace(old, new)

    replace_once(
        "import 'dart:async';\n",
        "import 'dart:async';\nimport 'dart:io';\n"
        "import 'package:analyzer/src/dart/analysis/file_byte_store.dart';\n",
    )

    replace_once(
        """  late final ByteStore _byteStore = MemoryCachingByteStore(
    NullByteStore(),
    1024 * 1024 * 256,
  );
""",
        """  static final String? probeByteStorePath =
      Platform.environment['PROBE_BYTE_STORE'];
  static final bool probeFineDeps =
      Platform.environment['PROBE_FINE_DEPS'] != '0';
  static final bool probePriorityAll =
      Platform.environment['PROBE_PRIORITY_ALL'] == '1';
  static final bool probeSkipRules =
      Platform.environment['PROBE_SKIP_RULES'] == '1';
  static final int probeMemoryMiB =
      int.tryParse(Platform.environment['PROBE_MEMORY_MIB'] ?? '') ?? 256;
  static final Stopwatch probeRuleStopwatch = Stopwatch();
  static int probeRuleLibraryCount = 0;
  static int probeResolvedUnitEvents = 0;
  static int probeErrorsResultEvents = 0;
  static final Map<String, int> probeCounters = {};
  static final Stopwatch probeProcessStopwatch = Stopwatch()..start();

  static void probeCount(String key) {
    probeCounters[key] = (probeCounters[key] ?? 0) + 1;
  }

  late final FileByteStore? _probeFileByteStore = probeByteStorePath == null
      ? null
      : FileByteStore(probeByteStorePath!, tempNameSuffix: 'probe');

  late final ByteStore _byteStore = MemoryCachingByteStore(
    _probeFileByteStore ?? NullByteStore(),
    1024 * 1024 * probeMemoryMiB,
  );

  void probeDumpStats(String reason) {
    var cc = _contextCollection;
    if (cc == null) return;
    var sb = StringBuffer();
    sb.writeln(
      '[probe] $reason at ${probeProcessStopwatch.elapsedMilliseconds} ms '
      'rss=${ProcessInfo.currentRss} maxRss=${ProcessInfo.maxRss}',
    );
    sb.writeln(
      '[probe] contexts=${cc.contexts.length} '
      'ruleLibraries=$probeRuleLibraryCount '
      'ruleMs=${probeRuleStopwatch.elapsedMilliseconds} '
      'resolvedUnitEvents=$probeResolvedUnitEvents '
      'errorsResultEvents=$probeErrorsResultEvents',
    );
    sb.writeln('[probe] counters=$probeCounters');
    for (var ctx in cc.contexts) {
      var d = ctx.driver;
      sb.writeln(
        '[probe] context ${ctx.contextRoot.root.path} '
        'added=${d.addedFiles.length} known=${d.knownFiles.length} '
        'loadedBundles=${d.libraryContext.loadedBundles.length}',
      );
    }
    var bs = _byteStore as MemoryCachingByteStore;
    sb.writeln(
      '[probe] memStore hit=${bs.cacheHitCount} miss=${bs.cacheMissCount} '
      'put=${bs.putCount} storeHit=${bs.storeHitCount} '
      'storeMiss=${bs.storeMissCount} size=${bs.currentSizeBytes} '
      'entries=${bs.entryCount} evictedEntries=${bs.evictedEntryCount} '
      'evictedBytes=${bs.evictedBytes}',
    );
    if (_probeFileByteStore case var f?) {
      sb.writeln(
        '[probe] fileStore reads=${f.readCount} misses=${f.readMissCount} '
        'writes=${f.writeCount}',
      );
    }
    if (Platform.environment['PROBE_PACKAGES'] == '1') {
      var counts = <String, int>{};
      var bytes = <String, int>{};
      for (var ctx in cc.contexts) {
        for (var file in ctx.driver.knownFiles) {
          var uri = file.uri;
          var key = uri.scheme == 'package'
              ? 'package:${uri.pathSegments.first}'
              : uri.scheme == 'dart'
              ? 'dart:'
              : 'file:';
          counts[key] = (counts[key] ?? 0) + 1;
          bytes[key] = (bytes[key] ?? 0) + file.content.length;
        }
      }
      var keys = counts.keys.toList()
        ..sort((a, b) => bytes[b]!.compareTo(bytes[a]!));
      for (var key in keys) {
        sb.writeln('[probe-package] $key files=${counts[key]} bytes=${bytes[key]}');
      }
    }
    sb.writeln('[probe] performance tree:');
    cc.scheduler.accumulatedPerformance.write(buffer: sb, indent: '    ');
    stderr.write(sb);
  }
""",
    )

    replace_once(
        "      withFineDependencies: true,\n",
        "      withFineDependencies: probeFineDeps,\n",
    )

    replace_once(
        """      for (var path in paths) {
        driver.addFile(path);
      }
    });
  }
""",
        """      if (probePriorityAll) {
        driver.priorityFiles = paths.toList();
      }
      for (var path in paths) {
        driver.addFile(path);
      }
    });
  }
""",
    )

    replace_once(
        """  void _handleAnalysisStatus(AnalysisStatus status) {
    _channel.sendNotification(
""",
        """  void _handleAnalysisStatus(AnalysisStatus status) {
    if (!status.isWorking) probeDumpStats('idle');
    _channel.sendNotification(
""",
    )

    replace_once(
        """      if (event is ResolvedUnitResult) {
        _handleResolvedUnit(event);
      } else if (event is AnalysisStatus) {
        _handleAnalysisStatus(event);
      } else if (event is ErrorsResult) {
        _handleErrorsResult(event);
      }
""",
        """      if (event is ResolvedUnitResult) {
        probeResolvedUnitEvents++;
        _handleResolvedUnit(event);
      } else if (event is AnalysisStatus) {
        _handleAnalysisStatus(event);
      } else if (event is ErrorsResult) {
        probeErrorsResultEvents++;
        _handleErrorsResult(event);
      }
""",
    )

    replace_once(
        """    var contextCollection = AnalysisContextCollectionImpl(
      resourceProvider: _resourceProvider,
""",
        """    var probeCreateStopwatch = Stopwatch()..start();
    var contextCollection = AnalysisContextCollectionImpl(
      resourceProvider: _resourceProvider,
""",
    )

    replace_once(
        """    await _analyzeAllFilesInContextCollection(
      contextCollection: contextCollection,
    );
  }
""",
        """    stderr.writeln(
      '[probe] contextCollectionCreated ms=${probeCreateStopwatch.elapsedMilliseconds} '
      'at ${probeProcessStopwatch.elapsedMilliseconds} ms',
    );
    await _analyzeAllFilesInContextCollection(
      contextCollection: contextCollection,
    );
    stderr.writeln(
      '[probe] filesAdded ms=${probeCreateStopwatch.elapsedMilliseconds} '
      'at ${probeProcessStopwatch.elapsedMilliseconds} ms',
    );
  }
""",
    )

    replace_once(
        """    if (unitResult.unit.declaredFragment !=
        unitResult.libraryElement.firstFragment) {
      return;
    }
    var session = unitResult.session;
    var activeSession = _filesBeingAnalyzed[unitResult.path];
    if (activeSession == session) {
      return;
    }
    _filesBeingAnalyzed[unitResult.path] = session;
    try {
      var file = _resourceProvider.getFile(unitResult.path);
      var analysisOptions = analysisContext.getAnalysisOptionsForFile(file);
      var libraryResult = await analysisContext.currentSession
          .getResolvedLibrary(unitResult.path);
      if (libraryResult is! ResolvedLibraryResult) return;
""",
        """    if (unitResult.unit.declaredFragment !=
        unitResult.libraryElement.firstFragment) {
      probeCount('resolvedUnit.notDefining');
      return;
    }
    var session = unitResult.session;
    var activeSession = _filesBeingAnalyzed[unitResult.path];
    if (activeSession == session) {
      probeCount('resolvedUnit.duplicateSession');
      return;
    }
    _filesBeingAnalyzed[unitResult.path] = session;
    probeCount('resolvedUnit.handled');
    try {
      var file = _resourceProvider.getFile(unitResult.path);
      var analysisOptions = analysisContext.getAnalysisOptionsForFile(file);
      var libraryResult = await analysisContext.currentSession
          .getResolvedLibrary(unitResult.path);
      if (libraryResult is! ResolvedLibraryResult) {
        probeCount('resolvedUnit.notResolvedLibrary.${libraryResult.runtimeType}');
        return;
      }
      probeCount('resolvedUnit.resolvedLibrary');
""",
    )

    replace_once(
        """    for (var configuration in configurations) {
      // TODO(srawlins): Enable timing similar to what the linter package's
      // `benchmark.dart` script does.
      var ruleVisitorRegistry = RuleVisitorRegistryImpl(enableTiming: false);
""",
        """    probeCount('analyzeAndSend.calls');
    probeCount('analyzeAndSend.configs.${configurations.length}');
    probeCount('analyzeAndSend.units.${allUnits.length}');
    for (var configuration in configurations) {
      // TODO(srawlins): Enable timing similar to what the linter package's
      // `benchmark.dart` script does.
      var ruleVisitorRegistry = RuleVisitorRegistryImpl(enableTiming: false);
""",
    )

    replace_once(
        """    for (var rule in rules) {
      // TODO(srawlins): Enable timing similar to what the linter package's
      // `benchmark.dart` script does.
      rule.registerNodeProcessors(ruleVisitorRegistry, context);
    }

    // Now to perform the actual analysis.
    for (var currentUnit in allUnits) {
""",
        """    probeCount('computeDiagnostics.rules.${rules.length}');
    if (probeSkipRules) return;
    probeRuleLibraryCount++;
    probeRuleStopwatch.start();
    for (var rule in rules) {
      // TODO(srawlins): Enable timing similar to what the linter package's
      // `benchmark.dart` script does.
      rule.registerNodeProcessors(ruleVisitorRegistry, context);
    }

    // Now to perform the actual analysis.
    for (var currentUnit in allUnits) {
""",
    )

    replace_once(
        """    AnalysisRuleVisitor(ruleVisitorRegistry).afterLibrary();
  }
""",
        """    AnalysisRuleVisitor(ruleVisitorRegistry).afterLibrary();
    probeRuleStopwatch.stop();
  }
""",
    )

    replace_once(
        """        await Future.wait(
          _plugins.map((p) => p.shutDown()).whereType<Future<Object?>>(),
        );
        _channel.sendResponse(
""",
        """        await Future.wait(
          _plugins.map((p) => p.shutDown()).whereType<Future<Object?>>(),
        );
        var probeFlush = Stopwatch()..start();
        await _probeFileByteStore?.flush();
        stderr.writeln(
          '[probe] shutdown flush ms=${probeFlush.elapsedMilliseconds} '
          'at ${probeProcessStopwatch.elapsedMilliseconds} ms',
        );
        probeDumpStats('shutdown');
        _channel.sendResponse(
""",
    )

    f.write_text(s)
    print('patched', f)


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('--source', default=str(DEFAULT_SOURCE))
    p.add_argument('--dest', required=True)
    p.add_argument('--tolerant', action='store_true', help='skip probes whose anchor text is missing (patched SDK branches)')
    a = p.parse_args()
    patch(Path(a.source), Path(a.dest), a.tolerant)


if __name__ == '__main__':
    main()
