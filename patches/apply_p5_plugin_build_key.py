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


if __name__ == '__main__':
    sdk = Path(sys.argv[1])
    patch_watcher(sdk)
    print('Check pkg/analysis_server/test/src/plugin/plugin_watcher_test.dart for folder-name expectations.')
