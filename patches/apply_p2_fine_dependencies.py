"""Apply patch 2 to a Dart SDK checkout: mirror the host's fine-dependency setting.

Usage: python3 apply_p2_fine_dependencies.py /path/to/sdk
       # then regenerate the protocol:
       cd /path/to/sdk && tools/sdks/dart-sdk/bin/dart pkg/analyzer_plugin/tool/spec/generate_all.dart

Adds an optional `withFineDependencies` field to the `plugin.versionCheck` request. The
analysis server passes its own setting; the plugin server uses it when creating its
analysis context collection instead of unconditionally enabling fine-grained
dependency tracking.
"""
import sys
from pathlib import Path


def replace_once(text, old, new):
    assert text.count(old) == 1, f'expected exactly one match for: {old[:90]!r}'
    return text.replace(old, new)


def patch_spec(sdk: Path):
    f = sdk / 'pkg/analyzer_plugin/tool/spec/plugin_spec.html'
    s = f.read_text()
    s = replace_once(
        s,
        """      <field name="version">
        <ref>String</ref>
        <p>
          The version number of the plugin spec supported by the analysis server
          that is executing the plugin.
        </p>
      </field>
    </params>
    <result>
      <field name="isCompatible">
""",
        """      <field name="version">
        <ref>String</ref>
        <p>
          The version number of the plugin spec supported by the analysis server
          that is executing the plugin.
        </p>
      </field>
      <field name="withFineDependencies" optional="true">
        <ref>bool</ref>
        <p>
          Whether the analysis server tracks fine-grained dependencies between
          libraries. Plugins should create their analysis contexts with the same
          setting. If omitted, fine-grained dependency tracking is disabled.
        </p>
      </field>
    </params>
    <result>
      <field name="isCompatible">
""",
    )
    f.write_text(s)
    print('patched', f)


def patch_plugin_server(sdk: Path):
    f = sdk / 'pkg/analysis_server_plugin/lib/src/plugin_server.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """  String? _sdkPath;
""",
        """  String? _sdkPath;

  /// Whether analysis contexts track fine-grained dependencies, as requested
  /// by the server in `plugin.versionCheck`.
  bool _withFineDependencies = false;
""",
    )
    s = replace_once(
        s,
        """    _sdkPath = parameters.sdkPath;
""",
        """    _sdkPath = parameters.sdkPath;
    _withFineDependencies = parameters.withFineDependencies ?? false;
""",
    )
    s = replace_once(
        s,
        "      withFineDependencies: true,\n",
        "      withFineDependencies: _withFineDependencies,\n",
    )
    s = replace_once(
        s,
        """  /// Initializes each of the registered plugins.
  Future<void> initialize() async {
""",
        """  /// The analysis context collection, for tests.
  @visibleForTesting
  AnalysisContextCollectionImpl? get contextCollectionForTesting =>
      _contextCollection;

  /// Initializes each of the registered plugins.
  Future<void> initialize() async {
""",
    )
    f.write_text(s)
    print('patched', f)


def patch_host(sdk: Path):
    f = sdk / 'pkg/analysis_server/lib/src/plugin/plugin_isolate.dart'
    s = f.read_text()
    s = replace_once(
        s,
        "  Future<PluginSession?> start(String? byteStorePath, String sdkPath) async {\n",
        "  Future<PluginSession?> start(\n    String? byteStorePath,\n    String sdkPath, {\n    bool withFineDependencies = false,\n  }) async {\n",
    )
    s = replace_once(
        s,
        "    var isRunning = await currentSession!.start(byteStorePath, sdkPath);\n",
        "    var isRunning = await currentSession!.start(\n      byteStorePath,\n      sdkPath,\n      withFineDependencies: withFineDependencies,\n    );\n",
    )
    s = replace_once(
        s,
        "  Future<bool> start(String? byteStorePath, String sdkPath) async {\n",
        "  Future<bool> start(\n    String? byteStorePath,\n    String sdkPath, {\n    bool withFineDependencies = false,\n  }) async {\n",
    )
    s = replace_once(
        s,
        "      PluginVersionCheckParams(byteStorePath, sdkPath, '1.0.0-alpha.0'),\n",
        "      PluginVersionCheckParams(\n        byteStorePath,\n        sdkPath,\n        '1.0.0-alpha.0',\n        withFineDependencies: withFineDependencies,\n      ),\n",
    )
    f.write_text(s)
    print('patched', f)

    f = sdk / 'pkg/analysis_server/lib/src/plugin/plugin_manager.dart'
    s = f.read_text()
    s = replace_once(
        s,
        "      var session = await pluginIsolate.start(_byteStorePath, _sdkPath);\n",
        "      var session = await pluginIsolate.start(\n        _byteStorePath,\n        _sdkPath,\n        withFineDependencies: withFineDependencies,\n      );\n",
    )
    f.write_text(s)
    print('patched', f, '(start call); the constructor parameter is added by hand, see below')


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_spec(sdk)
    patch_plugin_server(sdk)
    patch_host(sdk)
    print('''
Manual steps:
 1. PluginManager: add `this.withFineDependencies = false` as a named constructor
    parameter and a `final bool withFineDependencies;` field.
 2. AnalysisServer: pass `withFineDependencies: options.withFineDependencies` where
    PluginManager is constructed.
 3. Regenerate the protocol: tools/sdks/dart-sdk/bin/dart pkg/analyzer_plugin/tool/spec/generate_all.dart
''')
