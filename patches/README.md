# Patches against the Dart SDK

Each subdirectory holds one `git format-patch` output taken from a branch of a Dart SDK
checkout (`~/code/oss/dart-sdk/sdk`, gclient-managed), its measurement on the public
fixture, and notes on what the tests cover. The branches are also pushed to
https://github.com/cdeil/sdk (a fork used only for sharing; the Dart project accepts
changes through Gerrit, not GitHub pull requests).

Measurements are filled in as each patch is validated; see `../results/`.
