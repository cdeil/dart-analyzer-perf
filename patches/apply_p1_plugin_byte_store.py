"""Apply patch 1 to a Dart SDK checkout: persist the plugin byte store.

Usage: python3 apply_p1_plugin_byte_store.py /path/to/sdk

Changes pkg/analysis_server_plugin/lib/src/plugin_server.dart so that, once the server
sends `plugin.versionCheck` with a byte store path and the plugin runs on the physical
file system, analysis results are written through a FileByteStore in that directory (the
host's own cache directory, whose eviction the host owns), and pending writes are flushed
before the plugin answers `plugin.shutdown`. Adds behavioral tests.
"""
import sys
from pathlib import Path


def replace_once(text, old, new):
    assert text.count(old) == 1, f'expected exactly one match for: {old[:90]!r}'
    return text.replace(old, new)


def patch_server(sdk: Path):
    f = sdk / 'pkg/analysis_server_plugin/lib/src/plugin_server.dart'
    s = f.read_text()
    s = replace_once(s, "import 'dart:async';\n", "import 'dart:async';\nimport 'dart:isolate' show Isolate;\n")
    s = replace_once(
        s,
        "import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';\n",
        "import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';\n"
        "import 'package:analyzer/src/dart/analysis/file_byte_store.dart';\n",
    )
    s = replace_once(
        s,
        "import 'package:analyzer/file_system/overlay_file_system.dart';\n",
        "import 'package:analyzer/file_system/overlay_file_system.dart';\n"
        "import 'package:analyzer/file_system/physical_file_system.dart';\n",
    )
    s = replace_once(
        s,
        """  late final ByteStore _byteStore = MemoryCachingByteStore(
    NullByteStore(),
    1024 * 1024 * 256,
  );
""",
        """  /// The size of the in-memory layer of [_byteStore].
  static const int _memoryByteStoreSize = 1024 * 1024 * 256;

  /// The byte store used by every analysis context of this plugin.
  ///
  /// Until the server sends a `plugin.versionCheck` request with a byte store
  /// path, or when the plugin does not run on the physical file system, results
  /// are cached in memory only.
  ByteStore _byteStore = MemoryCachingByteStore(
    NullByteStore(),
    _memoryByteStoreSize,
  );

  /// The file-backed store behind [_byteStore], if any.
  ///
  /// The server owns the directory and its eviction; the plugin only reads and
  /// writes entries, and flushes pending writes before it shuts down.
  FileByteStore? _fileByteStore;
""",
    )
    s = replace_once(
        s,
        """    _sdkPath = parameters.sdkPath;
    return protocol.PluginVersionCheckResult(true, 'Plugin Server', '0.0.1', [
""",
        """    _sdkPath = parameters.sdkPath;
    _useFileByteStore(parameters.byteStorePath);
    return protocol.PluginVersionCheckResult(true, 'Plugin Server', '0.0.1', [
""",
    )
    s = replace_once(
        s,
        """  /// Initializes each of the registered plugins.
  Future<void> initialize() async {
""",
        """  /// The file-backed byte store, for tests.
  @visibleForTesting
  FileByteStore? get fileByteStoreForTesting => _fileByteStore;

  /// Backs [_byteStore] with a [FileByteStore] in [byteStorePath], if the
  /// path is not empty and the plugin runs on the physical file system.
  ///
  /// Several plugin isolates and the server itself can write to the same
  /// directory; the temporary file name suffix keeps their writes apart.
  void _useFileByteStore(String byteStorePath) {
    if (byteStorePath.isEmpty) return;
    if (_resourceProvider.baseProvider is! PhysicalResourceProvider) return;
    if (_contextCollection != null) return;
    var fileByteStore = _fileByteStore = FileByteStore(
      byteStorePath,
      tempNameSuffix: 'plugin-${Isolate.current.hashCode}',
    );
    _byteStore = MemoryCachingByteStore(fileByteStore, _memoryByteStoreSize);
  }

  /// Initializes each of the registered plugins.
  Future<void> initialize() async {
""",
    )
    s = replace_once(
        s,
        """        await Future.wait(
          _plugins.map((p) => p.shutDown()).whereType<Future<Object?>>(),
        );
        _channel.sendResponse(
          protocol.PluginShutdownResult().toResponse(request.id, requestTime),
        );
""",
        """        await Future.wait(
          _plugins.map((p) => p.shutDown()).whereType<Future<Object?>>(),
        );
        await _fileByteStore?.flush();
        _channel.sendResponse(
          protocol.PluginShutdownResult().toResponse(request.id, requestTime),
        );
""",
    )
    f.write_text(s)
    print('patched', f)


TEST_CLASS = r"""
/// Tests that run the plugin server on the physical file system, so that the
/// byte store can persist analysis results between plugin instances.
@reflectiveTest
class PluginServerByteStoreTest {
  late io.Directory tempDirectory;
  late Folder byteStoreRoot;
  late Folder sdkRoot;
  late Folder packageRoot;

  PhysicalResourceProvider get resourceProvider =>
      PhysicalResourceProvider.INSTANCE;

  Future<void> setUp() async {
    tempDirectory = io.Directory.systemTemp.createTempSync('plugin_byte_store');
    var root = resourceProvider.getFolder(tempDirectory.path);
    byteStoreRoot = root.getFolder('byteStore')..create();
    sdkRoot = resourceProvider.getFolder(getSdkPath());
    packageRoot = root.getFolder('package1')..create();
    packageRoot.getFolder('lib').create();
    packageRoot.getFile('analysis_options.yaml').writeAsStringSync('''
plugins:
  no_literals:
    path: some/path
''');
    packageRoot.getFolder('lib').getFile('test.dart')
        .writeAsStringSync('bool b = false;\n');
  }

  void tearDown() {
    PluginServer.registries.clear();
    registeredFixGenerators.clearLintProducers();
    registeredFixGenerators.clearWarningProducers();
    tempDirectory.deleteSync(recursive: true);
  }

  Future<void> test_persistsAcrossInstances() async {
    var first = await _analyzeWithNewServer();
    expect(first.errors, hasLength(1));
    expect(first.fileByteStore, isNotNull);
    expect(first.fileByteStore!.writeCount, greaterThan(0));
    expect(first.fileByteStore!.pendingWriteCount, 0);
    expect(byteStoreRoot.getChildren(), isNotEmpty);

    var second = await _analyzeWithNewServer();
    expect(second.errors, hasLength(1));
    expect(second.errors.single.message, first.errors.single.message);
    expect(second.fileByteStore!.readCount, greaterThan(0));
    expect(second.fileByteStore!.readMissCount,
        lessThan(second.fileByteStore!.readCount));
  }

  Future<({List<protocol.AnalysisError> errors, FileByteStore? fileByteStore})>
  _analyzeWithNewServer() async {
    PluginServer.registries.clear();
    registeredFixGenerators.clearLintProducers();
    registeredFixGenerators.clearWarningProducers();
    var channel = FakeChannel();
    var server = PluginServer(
      resourceProvider: resourceProvider,
      plugins: [_NoLiteralsPlugin()],
    );
    await server.initialize();
    server.start(channel);
    await server.handlePluginVersionCheck(
      protocol.PluginVersionCheckParams(byteStoreRoot.path, sdkRoot.path, '0.0.1'),
    );
    var testFile = packageRoot
        .getFolder('lib')
        .getFile('test.dart');
    var errorsQueue = StreamQueue(
      channel.notifications
          .where((n) => n.event == protocol.ANALYSIS_NOTIFICATION_ERRORS)
          .map((n) => protocol.AnalysisErrorsParams.fromNotification(n))
          .where((p) => p.file == testFile.path),
    );
    var contextRoot = protocol.ContextRoot(packageRoot.path, []);
    await Future.wait([
      channel.sendRequest(protocol.AnalysisSetContextRootsParams([contextRoot])),
      channel.sendRequest(
        protocol.AnalysisSetAnalysisRootsParams([contextRoot.root], []),
      ),
    ]);
    var params = await errorsQueue.next;
    await channel.sendRequest(protocol.PluginShutdownParams());
    return (errors: params.errors, fileByteStore: server.fileByteStoreForTesting);
  }
}
"""


def patch_tests(sdk: Path):
    f = sdk / 'pkg/analysis_server_plugin/test/src/plugin_server_test.dart'
    s = f.read_text()
    s = replace_once(s, "import 'dart:async';\n", "import 'dart:async';\nimport 'dart:io' as io;\n")
    s = replace_once(
        s,
        "import 'package:analysis_server_plugin/src/plugin_server.dart';\n",
        "import 'package:analysis_server_plugin/src/correction/fix_generators.dart';\n"
        "import 'package:analysis_server_plugin/src/plugin_server.dart';\n"
        "import 'package:analyzer/file_system/file_system.dart';\n"
        "import 'package:analyzer/file_system/physical_file_system.dart';\n"
        "import 'package:analyzer/src/dart/analysis/file_byte_store.dart';\n"
        "import 'package:analyzer/src/util/sdk.dart';\n",
    )
    s = replace_once(
        s,
        "  defineReflectiveTests(PluginServerTest);\n",
        "  defineReflectiveTests(PluginServerTest);\n  defineReflectiveTests(PluginServerByteStoreTest);\n",
    )
    s = replace_once(
        s,
        "@reflectiveTest\nclass PluginServerTest extends PluginServerTestBase with PluginServerTestMixin {\n",
        TEST_CLASS.lstrip('\n') + "\n@reflectiveTest\nclass PluginServerTest extends PluginServerTestBase with PluginServerTestMixin {\n",
    )
    s = replace_once(
        s,
        "  Future<void> test_diagnosticsCanBeIgnored() async {\n",
        "  Future<void> test_byteStore_memoryResourceProvider_noFileStore() async {\n"
        "    expect(pluginServer.fileByteStoreForTesting, isNull);\n"
        "  }\n\n"
        "  Future<void> test_diagnosticsCanBeIgnored() async {\n",
    )
    f.write_text(s)
    print('patched', f)


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_server(sdk)
    patch_tests(sdk)
