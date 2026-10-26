"""Apply patch 6 to a Dart SDK checkout: skip the startup cache scan after a recent one.

Usage: python3 apply_p6_eviction_stamp.py /path/to/sdk

EvictingFileByteStore scans the whole cache directory (stat of every file, 330k files and
4.7 GB on a busy machine) in its constructor, that is at every `dart analyze` start. The
cleanup now records a stamp file when it finishes, and a new store skips the startup scan
while the stamp is younger than an hour. Writes still trigger a scan after maxSize/8 bytes.
"""
import sys
from pathlib import Path


def replace_once(text, old, new):
    assert text.count(old) == 1, f'expected exactly one match for: {old[:90]!r}'
    return text.replace(old, new)


def patch_store(sdk: Path):
    f = sdk / 'pkg/analyzer/lib/src/dart/analysis/file_byte_store.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """  new(this._cachePath, this._maxSizeBytes)
    : _fileByteStore = FileByteStore(_cachePath) {
    _requestCacheCleanUp();
  }
""",
        """  /// The name of the file in the cache directory whose modification time
  /// records when the last clean up finished.
  static const String cleanUpStampName = '.clean-up-stamp';

  /// How long a clean up stamp makes new stores skip the start-up scan.
  static const Duration cleanUpStampMaxAge = Duration(hours: 1);

  new(this._cachePath, this._maxSizeBytes)
    : _fileByteStore = FileByteStore(_cachePath) {
    if (!_hasRecentCleanUpStamp()) {
      _requestCacheCleanUp();
    }
  }
""",
    )
    s = replace_once(
        s,
        """  /// If the cache clean up process has not been requested yet, request it.
  void _requestCacheCleanUp() async {
""",
        """  /// Whether a clean up finished recently enough that the start-up scan can
  /// be skipped.
  ///
  /// Writes by this store still request a clean up after `_maxSizeBytes / 8`
  /// bytes, so the directory stays bounded; the stamp only avoids rescanning
  /// an unchanged directory from every new process.
  bool _hasRecentCleanUpStamp() {
    try {
      var stamp = File(join(_cachePath, cleanUpStampName));
      var modified = stamp.lastModifiedSync();
      return DateTime.now().difference(modified) < cleanUpStampMaxAge;
    } catch (_) {
      return false;
    }
  }

  /// If the cache clean up process has not been requested yet, request it.
  void _requestCacheCleanUp() async {
""",
    )
    s = replace_once(
        s,
        """    for (FileSystemEntity resource in resources) {
      if (resource is File) {
        try {
""",
        """    for (FileSystemEntity resource in resources) {
      if (resource is File) {
        if (basename(resource.path) == cleanUpStampName) continue;
        try {
""",
    )
    s = replace_once(
        s,
        """      } catch (_) {}
    }

    return CacheCleanUpResult(
      currentSizeBytes: currentSizeBytes,
""",
        """      } catch (_) {}
    }

    try {
      File(join(cachePath, cleanUpStampName)).writeAsStringSync('');
    } catch (_) {}

    return CacheCleanUpResult(
      currentSizeBytes: currentSizeBytes,
""",
    )
    f.write_text(s)
    print('patched', f)


TEST = r"""
@reflectiveTest
class EvictingFileByteStoreTest {
  late Directory tempDirectory;

  void setUp() {
    tempDirectory = Directory.systemTemp.createTempSync('evicting_byte_store');
  }

  void tearDown() {
    tempDirectory.deleteSync(recursive: true);
  }

  Future<void> test_startUpScan_skippedAfterRecentCleanUp() async {
    var first = EvictingFileByteStore(tempDirectory.path, 1024 * 1024);
    await first.cleanUpFutureForTesting;
    expect(first.cleanUpCount, 1);
    var stamp = File(
      join(tempDirectory.path, EvictingFileByteStore.cleanUpStampName),
    );
    expect(stamp.existsSync(), isTrue);

    var second = EvictingFileByteStore(tempDirectory.path, 1024 * 1024);
    expect(second.cleanUpFutureForTesting, isNull);
    expect(second.cleanUpCount, 0);

    stamp.setLastModifiedSync(
      DateTime.now().subtract(const Duration(hours: 2)),
    );
    var third = EvictingFileByteStore(tempDirectory.path, 1024 * 1024);
    await third.cleanUpFutureForTesting;
    expect(third.cleanUpCount, 1);
  }

  Future<void> test_startUpScan_ignoresStamp() async {
    var store = EvictingFileByteStore(tempDirectory.path, 1024 * 1024);
    await store.cleanUpFutureForTesting;
    expect(store.lastScannedFileCount, 0);
  }
}
"""


def patch_store_testing_hooks(sdk: Path):
    f = sdk / 'pkg/analyzer/lib/src/dart/analysis/file_byte_store.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """    if (!_hasRecentCleanUpStamp()) {
      _requestCacheCleanUp();
    }
  }
""",
        """    if (!_hasRecentCleanUpStamp()) {
      _cleanUpFuture = _requestCacheCleanUp();
    }
  }

  /// The clean up requested by the constructor, if any, for tests.
  Future<void>? _cleanUpFuture;

  Future<void>? get cleanUpFutureForTesting => _cleanUpFuture;
""",
    )
    s = replace_once(
        s,
        """  /// If the cache clean up process has not been requested yet, request it.
  void _requestCacheCleanUp() async {
""",
        """  /// If the cache clean up process has not been requested yet, request it.
  Future<void> _requestCacheCleanUp() async {
""",
    )
    f.write_text(s)


def patch_tests(sdk: Path):
    f = sdk / 'pkg/analyzer/test/src/dart/analysis/file_byte_store_test.dart'
    s = f.read_text()
    s = replace_once(
        s,
        "    defineReflectiveTests(FileByteStoreValidatorTest);\n",
        "    defineReflectiveTests(EvictingFileByteStoreTest);\n    defineReflectiveTests(FileByteStoreValidatorTest);\n",
    )
    s = replace_once(s, "\n@reflectiveTest\nclass FileByteStoreValidatorTest {", TEST.rstrip('\n') + "\n\n@reflectiveTest\nclass FileByteStoreValidatorTest {")
    if "import 'dart:io';" not in s:
        s = replace_once(s, "import 'dart:typed_data';\n", "import 'dart:io';\nimport 'dart:typed_data';\n")
    if "import 'package:path/path.dart';" not in s:
        s = replace_once(s, "import 'package:test/test.dart';\n", "import 'package:path/path.dart';\nimport 'package:test/test.dart';\n")
    f.write_text(s)
    print('patched', f)


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_store(sdk)
    patch_store_testing_hooks(sdk)
    patch_tests(sdk)
