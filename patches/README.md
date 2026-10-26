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
| 1 | `plugin-byte-store` | tests pass (49), analyzer clean | main: 4.4, 4.7 cold. Branch: 5.1 cold (first run writes 88 MB), **1.55, 1.57 warm**, identical findings |
| 2 | `driver-recent-libraries` | tests pass (16 filtered + full suite, see commits) | pending |
| 3 | `plugin-fine-dependencies` | pending | |
| 4 | `byte-store-scan` | pending | |
| 5 | `plugin-build-key` | pending | |

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
