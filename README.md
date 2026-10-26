# dart-analyzer-perf

Reproducible measurements of where `dart analyze` spends its time when a native analyzer
plugin (here `riverpod_lint`) is enabled, and prototypes of the upstream changes that make
repeated runs cheap. Everything runs against a synthetic, public Flutter + Riverpod
workspace, so anyone with the pinned Flutter SDK can reproduce it; the private production
app that prompted this work is only referred to by aggregate numbers.

## Result in one table

Plugin isolate, seconds from process start to "analysis complete", on the public fixture
(666 Dart files, 3,201-file import closure, 15 Riverpod rules), Apple M5 Pro, Dart SDK `main`
of 26 October 2026 as runtime:

| Configuration | First run | Later runs | Findings |
| --- | --- | --- | --- |
| `analysis_server_plugin` as shipped (memory-only cache, fine dependencies on) | 4.4 to 4.7 | 4.4 to 4.7 | 2 |
| + persistent `FileByteStore` (branch `plugin-byte-store`, dart-lang/sdk#64202) | 5.1 | 1.55 | 2 |
| + plugin mirrors the host's fine-dependency setting (`plugin-fine-dependencies`) | 3.4 to 3.8 | 1.3 | 2 |
| + driver keeps recently resolved libraries (`driver-recent-libraries`) | 3.7 | **1.1 to 1.2** | 2 |

The same mechanisms on a private 7,481-file Flutter workspace: plugin isolate 12.5 to 15.7 s
today; 2.0 to 2.5 s warm with the first two changes. Diagnostics are identical in every
configuration (`results/*.jsonl` keep the sorted identities). Two further branches address
the host: `byte-store-scan` skips the server's start-up scan of its cache directory (about
2 s per run on a 4.7 GB cache), and `plugin-build-key` stops recompiling the plugin for
every checkout of the same project (12 to 30 s each).

Why the plugin is slow today: it runs a second, complete analyzer in its own isolate with
no persistent cache, so every `dart analyze` relinks the whole import closure (on the private
workspace: 4.3 s reading and parsing 6,697 files, 5.4 s linking 3,359 library cycles, 2.6 s
fine-dependency manifests, 2 × 1 s resolving the app twice, 0.1 s of actual rules). A cold
`dart analyze --no-plugins` with an emptied cache costs 18 to 19.5 s on that workspace, more
than the 15 s plugin run. See `notes/analyzer-architecture.md`.

## What is in here

| Path | Purpose |
| --- | --- |
| `fixtures/generate_workspace.py` | Generates `fixtures/riverpod_workspace`: three pub-workspace packages, hand-written Riverpod 3 providers and widgets, heavy dependencies (dio, go_router, pdf, printing, image, ...), and two planted rule violations as parity sentinels |
| `bench/analyze_bench.py` | Times complete `dart analyze --fatal-infos` runs with a private analyzer state directory and records CPU time and the sorted diagnostics |
| `bench/plugin_probe/` | Runs the real `analysis_server_plugin` server in-process, against pub packages or a Dart SDK checkout, with environment-controlled probes, and prints the analyzer's own phase timings |
| `bench/rohd_bench.sh` | Runs the public ROHD no-op plugin reproducer from dart-lang/sdk#63292 |
| `results/` | Raw JSONL rows (every run, with findings) and the ROHD output |
| `patches/` | `apply_*.py` scripts that reproduce each branch on a Dart SDK checkout, the exported diffs, measurements and test commands |
| `drafts/` | Issue comment, new issues and change descriptions prepared for upstream (not posted) |
| `notes/` | How the analyzer and plugin host work, the Dart contribution process and AI policy, status |

The SDK branches are also pushed to https://github.com/cdeil/sdk for reading; the Dart
project takes changes through Gerrit, not GitHub pull requests.

## Quick start

```bash
# Flutter 3.47.8 / Dart 3.13.7 are pinned through fvm; any 3.13.x works for the fixture.
export DART_BIN=$HOME/fvm/versions/3.47.8/bin/dart
export DART_SDK=$HOME/fvm/versions/3.47.8/bin/cache/dart-sdk
make fixture      # generate and resolve the workspace
make bench        # complete-check timings (first run compiles the plugin, about 30 s)
make probe        # plugin-side phase timings, as shipped and with a persistent store

# Against a Dart SDK checkout (gclient) on one of the patch branches:
python3 bench/plugin_probe/build_probe.py --name p1 --sdk-pkg ~/code/oss/dart-sdk/sdk/pkg \
    --dart ~/code/oss/dart-sdk/sdk/tools/sdks/dart-sdk/bin/dart
python3 bench/plugin_probe/probe_run.py --project fixtures/riverpod_workspace \
    --sdk ~/code/oss/dart-sdk/sdk/tools/sdks/dart-sdk --harness p1 --label p1 --store p1 --fresh-store --repeat 3
```

Large regenerable state (analyzer caches, compiled probes, SDK checkouts) lives under
`~/data/dart-analyzer-perf` (override with `DART_ANALYZER_PERF_DATA`).

## License

MIT, see `LICENSE`. Patched copies of `analysis_server_plugin` produced by the probe
builder and the exported SDK diffs keep the Dart project's BSD license.
