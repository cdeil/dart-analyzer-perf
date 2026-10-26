"""Apply patch 3 to a Dart SDK checkout: cache recently resolved libraries in the driver.

Usage: python3 apply_p3_driver_recent_libraries.py /path/to/sdk

AnalysisDriver only served getResolvedLibrary from a cache for libraries that contain
priority files. A client that reacts to a ResolvedUnitResult event by asking for the
whole library (analysis_server_plugin does) therefore paid a second full resolution of
every library. This keeps the few most recently produced ResolvedLibraryResults, with the
same invalidation as the priority cache, so an immediately following request is a hit.
"""
import sys
from pathlib import Path

CAPACITY = 8


def replace_once(text, old, new):
    assert text.count(old) == 1, f'expected exactly one match for: {old[:90]!r}'
    return text.replace(old, new)


def patch_driver(sdk: Path):
    f = sdk / 'pkg/analyzer/lib/src/dart/analysis/driver.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """  /// Cached results of [getResolvedLibrary].
  final Map<String, ResolvedLibraryResultImpl> _resolvedLibraryCache = {};
""",
        f"""  /// Cached results of [getResolvedLibrary].
  final Map<String, ResolvedLibraryResultImpl> _resolvedLibraryCache = {{}};

  /// The most recently produced results of libraries without priority files,
  /// in production order, so that a [getResolvedLibrary] request that follows
  /// the [ResolvedUnitResult] events of a library does not resolve it again.
  ///
  /// Bounded to [_recentResolvedLibrariesCapacity] entries; invalidated
  /// together with [_resolvedLibraryCache].
  final Map<String, ResolvedLibraryResultImpl> _recentResolvedLibraries = {{}};

  static const int _recentResolvedLibrariesCapacity = {CAPACITY};
""",
    )
    # Invalidation sites: every `_resolvedLibraryCache.clear();` also clears the recent map.
    count = s.count("      _resolvedLibraryCache.clear();\n")
    assert count == 3, count
    s = s.replace(
        "      _resolvedLibraryCache.clear();\n",
        "      _resolvedLibraryCache.clear();\n      _recentResolvedLibraries.clear();\n",
    )
    s = replace_once(
        s,
        "    _priorityResults.clear();\n    _resolvedLibraryCache.clear();\n",
        "    _priorityResults.clear();\n    _resolvedLibraryCache.clear();\n    _recentResolvedLibraries.clear();\n",
    )
    # Lookup in getResolvedLibrary() and in the scheduled request path.
    assert s.count("    if (_resolvedLibraryCache[path] case var cached?) {\n") == 2
    s = s.replace(
        "    if (_resolvedLibraryCache[path] case var cached?) {\n",
        "    if (_resolvedLibraryCache[path] ?? _recentResolvedLibraries[path]\n"
        "        case var cached?) {\n",
    )
    s = replace_once(
        s,
        """        if (isLibraryWithPriorityFile) {
          _resolvedLibraryCache[library.file.path] = libraryResult;
        }
""",
        """        if (isLibraryWithPriorityFile) {
          _resolvedLibraryCache[library.file.path] = libraryResult;
        } else {
          _recentResolvedLibraries.remove(library.file.path);
          _recentResolvedLibraries[library.file.path] = libraryResult;
          if (_recentResolvedLibraries.length >
              _recentResolvedLibrariesCapacity) {
            _recentResolvedLibraries.remove(_recentResolvedLibraries.keys.first);
          }
        }
""",
    )
    f.write_text(s)
    print('patched', f)


TEST = r"""
  test_getResolvedLibrary_afterProduceErrors_reusesRecent() async {
    var a = newFile('$testPackageLibPath/a.dart', r'''
class A {}
''');

    var driver = driverFor(testFile);
    var collector = DriverEventCollector(driver);

    // Not a priority file: analyzed by the `produceErrors` loop.
    driver.addFile2(a);
    await assertEventsText(collector, r'''
[status] working
[operation] analyzeFile
  file: /home/test/lib/a.dart
  library: /home/test/lib/a.dart
[stream]
  ResolvedUnitResult #0
    path: /home/test/lib/a.dart
    uri: package:test/a.dart
    flags: exists isLibrary
[status] idle
''');

    // The library was just produced, so no second analysis is needed.
    collector.getResolvedLibrary('A1', a);
    await assertEventsText(collector, r'''
[future] getResolvedLibrary A1
  ResolvedLibraryResult #1
    element: package:test/a.dart
    units
      ResolvedUnitResult #0
''');

    // A change invalidates the recent result.
    driver.changeFile2(a);
    collector.getResolvedLibrary('A2', a);
    await assertEventsText(collector, r'''
[status] working
[operation] analyzeFile
  file: /home/test/lib/a.dart
  library: /home/test/lib/a.dart
[operation] reuseLinkedBundle
  package:test/a.dart
[stream]
  ResolvedUnitResult #2
    path: /home/test/lib/a.dart
    uri: package:test/a.dart
    flags: exists isLibrary
[status] idle
[future] getResolvedLibrary A2
  ResolvedLibraryResult #3
    element: package:test/a.dart
    units
      ResolvedUnitResult #2
''');
  }

  test_getResolvedLibrary_cachePriority() async {"""


def patch_tests(sdk: Path):
    f = sdk / 'pkg/analyzer/test/src/dart/analysis/driver_test.dart'
    s = f.read_text()
    s = replace_once(s, "\n  test_getResolvedLibrary_cachePriority() async {", TEST.rstrip('\n'))
    f.write_text(s)
    print('patched', f)


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_driver(sdk)
    patch_tests(sdk)
