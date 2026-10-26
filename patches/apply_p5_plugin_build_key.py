"""Apply patch 5 to a Dart SDK checkout: key plugin builds by their content.

Usage: python3 apply_p5_plugin_build_key.py /path/to/sdk

The shared plugin package (pubspec, entrypoint, resolved dependencies and the AOT
snapshot) was stored in a folder named by the consuming context root, so every checkout or
git worktree of the same project rebuilt the same plugins (dart-lang/sdk#63244). The folder
is now named by the generated pubspec content, which already encodes every plugin's name,
source and the dependency overrides, plus the SDK version that the manager mixes in.
"""
import sys
from pathlib import Path


def replace_once(text, old, new):
    assert text.count(old) == 1, f'expected exactly one match for: {old[:90]!r}'
    return text.replace(old, new)


def patch_watcher(sdk: Path):
    f = sdk / 'pkg/analysis_server/lib/src/plugin/plugin_watcher.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """      // TODO(srawlins): Better to name the folder based on a hash of the...
      // maybe the plugin names. Maybe the configutations.
      var folderName = groups.length == 1
          ? contextRoot.root.path
          : '${contextRoot.root.path}_group_$i';
      var sharedPluginFolder = manager.pluginStateFolder(folderName);
""",
        """      // The folder is named by the generated pubspec, so that every context
      // root that enables the same plugins from the same sources shares one
      // resolved and compiled plugin package.
      var newPubspecContent = packageGenerator.generatePubspec();
      var sharedPluginFolder = manager.pluginStateFolder(newPubspecContent);
""",
    )
    s = replace_once(
        s,
        """      var pubspecFile = sharedPluginFolder.getFile(file_paths.pubspecYaml);
      var newPubspecContent = packageGenerator.generatePubspec();
      // Only write the pubspec if it is different, to support caching.
""",
        """      var pubspecFile = sharedPluginFolder.getFile(file_paths.pubspecYaml);
      // Only write the pubspec if it is different, to support caching.
""",
    )
    f.write_text(s)
    print('patched', f)


def patch_manager_doc(sdk: Path):
    f = sdk / 'pkg/analysis_server/lib/src/plugin/plugin_manager.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """  /// Returns the "plugin state" folder for a plugin at [pluginPath].
  ///
  /// This is a directory under the state location for '.plugin_manager', named
  /// with a hash based on [pluginPath] and the version of the Dart SDK.
  Folder pluginStateFolder(String pluginPath) {
""",
        """  /// Returns the "plugin state" folder for the plugin package identified by
  /// [key]: the path of a legacy plugin, or the generated pubspec of a shared
  /// plugin package, so that every context root enabling the same plugins
  /// from the same sources shares one resolved and compiled package.
  ///
  /// This is a directory under the state location for '.plugin_manager', named
  /// with a hash based on [key] and the version of the Dart SDK.
  Folder pluginStateFolder(String key) {
""",
    )
    s = replace_once(
        s,
        "    var stateName = _uniqueDirectoryName(pluginPath);\n    return stateFolder.getFolder(stateName);\n",
        "    var stateName = _uniqueDirectoryName(key);\n    return stateFolder.getFolder(stateName);\n",
    )
    f.write_text(s)
    print('patched', f)


def patch_mock(sdk: Path):
    f = sdk / 'pkg/analysis_server/lib/src/utilities/mocks.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """  @override
  Folder pluginStateFolder(String contextRootPath) {
    return resourceProvider.getFolder(
      resourceProvider.pathContext.join(contextRootPath, '.plugin_state'),
    );
  }
""",
        """  @override
  Folder pluginStateFolder(String key) {
    var pathContext = resourceProvider.pathContext;
    return resourceProvider.getFolder(
      pathContext.join(
        '${pathContext.separator}plugin_state',
        (key.hashCode & 0x7fffffff).toRadixString(16),
      ),
    );
  }
""",
    )
    f.write_text(s)
    print('patched', f)


def patch_watcher_test(sdk: Path):
    """The conflicting-plugins test told the two plugin groups apart by a
    `_group_1` substring of the folder path; folders are now named by content,
    so it identifies them by the plugin constraint in each folder's pubspec."""
    f = sdk / 'pkg/analysis_server/test/src/plugin/plugin_watcher_test.dart'
    s = f.read_text()
    s = replace_once(
        s,
        """    var isolate0 = manager.pluginIsolates.firstWhere(
      (e) => !e.pluginId.contains('_group_1'),
    ) as TestPluginIsolate;
    var isolate1 = manager.pluginIsolates.firstWhere(
      (e) => e.pluginId.contains('_group_1'),
    ) as TestPluginIsolate;
""",
        """    String pubspecOf(TestPluginIsolate isolate) =>
        getFolder(isolate.pluginId).getFile('pubspec.yaml').readAsStringSync();
    // The plugin folders are named by their content; the group with the
    // inner options' `foo: ^2.0.0` comes first.
    var isolate0 = manager.pluginIsolates.firstWhere(
      (e) => pubspecOf(e as TestPluginIsolate).contains('2.0.0'),
    ) as TestPluginIsolate;
    var isolate1 = manager.pluginIsolates.firstWhere(
      (e) => pubspecOf(e as TestPluginIsolate).contains('1.0.0'),
    ) as TestPluginIsolate;
""",
    )
    f.write_text(s)
    print('patched', f)


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_watcher(sdk)
    patch_manager_doc(sdk)
    patch_mock(sdk)
    patch_watcher_test(sdk)
