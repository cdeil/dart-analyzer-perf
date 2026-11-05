# Patches against the Dart SDK

Each subdirectory holds the diff of one branch of a gclient-managed Dart SDK checkout
(`~/code/oss/dart-sdk/sdk`, `main` at `f2f81decfc9`, 2026-10-26) exported with
`patches/sdk_workflow.sh export <name>`, plus `commits.txt`. The `apply_*.py` scripts
reproduce each diff on a fresh checkout; they are a convenience, the reviewed artifact is the
branch. The Dart project accepts changes through Gerrit only (see
`notes/contributing-to-dart.md`).

Measurements use `bench/plugin_probe` built against the branch (`build_probe.py --sdk-pkg`)
and run on `fixtures/riverpod_workspace` (3,201-file closure) with the checkout's prebuilt
Dart 3.15.0-40.0.dev as runtime; raw rows are in `results/sdk-main-probe.jsonl` and
`results/sdk-branches-probe.jsonl`. "To idle" is the time from process start until the
plugin reports that analysis is complete.

| # | Branch | Status | Fixture result (plugin isolate, seconds to idle) |
| --- | --- | --- | --- |
| 1 | `plugin-byte-store` | **uploaded: CL 574481** (5 Nov); tests pass (49), analyzer clean | main: 4.4, 4.7 cold. Branch: 5.1 cold (first run writes 88 MB), **1.55, 1.57 warm**, identical findings |
| 2 | `driver-recent-libraries` | **uploaded: CL 574462** (5 Nov, issue #64862); tests pass (driver suite 1,303, plugin 47), analyzer clean | `ResolvedUnitResult` events 1,330 → 665, `analyzeFile` 1,330 → 665; cold 4.1 to 4.5 (main 4.4 to 4.7); warm with the probe's file store 1.32 to 1.36 (main 1.54 to 1.57) |
| 3 | `plugin-fine-dependencies` | **withdrawn**: the server already defaults to fine dependencies (since 3.12), so mirroring it changes nothing; measured numbers were with the setting forced off. Tests passed (plugin 49, plugin_isolate 23, plugin_manager 36, analyzer_plugin 1,183), analysis clean | plugin defaults to the host's setting (off): cold 3.4, 3.8 (main 4.4 to 4.7); warm with the probe's file store 1.28 to 1.30 (main 1.54 to 1.57); `computeManifests` gone, `link` 1.67 → 1.35 s |
| 4 | `byte-store-scan` | held back: an hour without start-up scans lets many short processes grow the cache unchecked; tests pass (8) | `bench/scan_cost.sh`: 330,000 extra cache files cost 0.6 to 0.8 s per warm `dart analyze` (1.05 → 1.63 to 1.85 s); the branch skips that scan when one finished within the hour |
| 5 | `plugin-build-key` | **discussion only**: upstream CL 569682 (27 Oct) chose context root + pubspec hash as the folder name; raise on #63244. Tests passed (watcher 10, manager 36) | server-side; no probe measurement (saves the 12 to 30 s plugin compile per additional checkout of the same project) |
| 1+2+3 | `plugin-perf-combined` | superseded: includes the withdrawn branch 3 | cold 3.7; warm 1.10 to 1.17, but only with fine dependencies forced off; with the default, branches 1+2 give 1.32 to 1.36 warm |

## 1. `plugin-byte-store`

`pkg/analysis_server_plugin/lib/src/plugin_server.dart`: when `plugin.versionCheck` carries a
non-empty byte store path and the plugin runs on the physical file system, the memory cache
is backed by `FileByteStore(byteStorePath, tempNameSuffix: 'plugin-<isolate hash>')`; pending
writes are flushed before the `plugin.shutdown` response. Eviction stays with the server,
which owns the directory (`EvictingFileByteStore`'s documentation already prescribes this for
plugins). Tests: a physical-file-system test starts two plugin servers in sequence on one
store directory and checks that the second reads entries and reports the same diagnostic,
and that the memory resource provider used by the other tests gets no file store.

Differences from CL 543560 PS1: no `EvictingFileByteStore` constructor change (unused by the
plugin), a guard for non-physical resource providers, the shutdown flush, and behavioral
tests instead of constructor assertions.

## Running the tests

```bash
cd ~/code/oss/dart-sdk/sdk
tools/sdks/dart-sdk/bin/dart pkg/analysis_server_plugin/test/src/plugin_server_test.dart
tools/sdks/dart-sdk/bin/dart pkg/analyzer/test/src/dart/analysis/file_byte_store_test.dart
(cd pkg/analyzer && ../../tools/sdks/dart-sdk/bin/dart test test/src/dart/analysis/driver_test.dart -N getResolvedLibrary)
tools/sdks/dart-sdk/bin/dart analyze pkg/analysis_server_plugin pkg/analyzer
```

## 2. `driver-recent-libraries`

`pkg/analyzer/lib/src/dart/analysis/driver.dart`: `_recentResolvedLibraries`, a bounded (8
entries) insertion-ordered map of `ResolvedLibraryResultImpl`s for libraries without
priority files, filled in `_analyzeFileImpl`, consulted by `getResolvedLibrary` (and the
scheduled request path), cleared wherever `_resolvedLibraryCache` is cleared. Test:
`test_getResolvedLibrary_afterProduceErrors_reusesRecent` asserts no second `analyzeFile`
after `addFile` + `getResolvedLibrary`, and re-analysis after `changeFile`. Two plugin
server tests (`test_setConfigurations_*`) relied on the initial analysis not having reported
before `analysis.setConfigurations`; with diagnostics arriving earlier they now consume the
initial notifications first.

## 4. `byte-store-scan`

`pkg/analyzer/lib/src/dart/analysis/file_byte_store.dart`: the clean-up isolate writes
`.clean-up-stamp` in the cache directory when it finishes; `EvictingFileByteStore`'s
constructor skips the start-up scan while the stamp is younger than an hour. Writes still
trigger a clean up after `maxSizeBytes / 8`. Tests cover skip, expiry and that the stamp is
not counted as a cache file.

## 3. `plugin-fine-dependencies`

`pkg/analyzer_plugin/tool/spec/plugin_spec.html`: optional `withFineDependencies` field on
`plugin.versionCheck`; `protocol_generated.dart`, `protocol_constants.dart`, `doc/api.html`
and the integration matchers are regenerated with `tool/spec/generate_all.dart`.
`PluginManager` gets a `withFineDependencies` constructor parameter that `AnalysisServer`
fills from its options and `PluginIsolate`/`PluginSession.start` forward in the version
check. `PluginServer` stores the value and uses it in `_createContextCollection` (default
false, the server's default). Tests: the plugin's driver has fine dependencies off by
default and on when the version check asks for it.

## 5. `plugin-build-key`

`pkg/analysis_server/lib/src/plugin/plugin_watcher.dart` names the shared plugin folder by
the generated pubspec content instead of the context root path; `PluginManager.
pluginStateFolder` keeps hashing its argument with the SDK version. The test mock derives a
folder from a hash of the key, and the conflicting-plugins watcher test identifies its two
groups by the constraint in each folder's pubspec instead of a `_group_1` path fragment.

## Combined: `plugin-perf-combined`

Cherry-picks of branches 1, 2 and 3 (two trivial adjacent-insertion conflicts resolved by
keeping both sides). This is the configuration a `dart analyze` user would get once the
three changes land: on the fixture the plugin isolate needs 3.7 s on the first run (it
writes 53 MB of cache) and 1.1 to 1.2 s on later runs, against 4.4 to 4.7 s every run today.
Scaled to the private 7,481-file workspace, where the plugin isolate takes 12.5 to 15.7 s
today and the warm host about 2 s, this puts the whole `dart analyze` run at roughly 3 s
instead of 15 s; the plugin side alone was measured at 2.0 to 2.5 s warm with the first two
mechanisms and partial rule coverage, and 4.1 to 4.3 s with full coverage before the
driver cache.
