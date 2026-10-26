# dart-analyzer-perf

Reproducible measurements of where `dart analyze` spends its time when a native analyzer
plugin (here `riverpod_lint`) is enabled, and prototypes of the upstream changes that
would make repeated runs cheap. Work in progress; numbers and patches are being added.

Everything here runs against a synthetic, public Flutter + Riverpod workspace, so anyone
with the pinned Flutter SDK can reproduce it. The private production app that prompted
this work is only referred to by aggregate numbers.

## What is in here

| Path | Purpose |
| --- | --- |
| `fixtures/generate_workspace.py` | Generates `fixtures/riverpod_workspace`: three pub-workspace packages, 666 Dart files, hand-written Riverpod 3 providers and widgets, heavy dependencies (dio, go_router, pdf, printing, image, ...), and two planted rule violations as parity sentinels |
| `bench/analyze_bench.py` | Times complete `dart analyze --fatal-infos` runs with a private analyzer state directory and records CPU time and the sorted diagnostics |
| `bench/plugin_probe/` | Runs the real `analysis_server_plugin` server in-process against a project with environment-controlled probes (persistent byte store, fine dependencies off, priority files) and prints the analyzer's own phase timings |
| `results/` | Raw JSONL results |
| `notes/` | How the analyzer and the plugin host work, with file references |
| `patches/` | Patches against the Dart SDK `main` branch with their measurements |
| `drafts/` | Issue and change descriptions prepared for upstream |

## Quick start

```bash
# Flutter 3.47.8 / Dart 3.13.7 are pinned through fvm; any 3.13.x works for the fixture.
export DART_BIN=$HOME/fvm/versions/3.47.8/bin/dart
export DART_SDK=$HOME/fvm/versions/3.47.8/bin/cache/dart-sdk
python3 fixtures/generate_workspace.py fixtures/riverpod_workspace
(cd fixtures/riverpod_workspace && flutter pub get)

# Complete-check timings; the first run compiles the plugin (about 30 s).
python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label warmup
python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label plugin --repeat 3
python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label noplugin --no-plugins --repeat 3
python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label noplugin-cold --no-plugins --fresh-state --repeat 2

# Plugin-side phase timings.
python3 bench/plugin_probe/build_probe.py
python3 bench/plugin_probe/probe_run.py --project fixtures/riverpod_workspace --label as-shipped --repeat 2
python3 bench/plugin_probe/probe_run.py --project fixtures/riverpod_workspace --label persistent --store s1 --fresh-store --repeat 3 --env PROBE_FINE_DEPS=0
```

Large regenerable state (analyzer caches, the compiled probe, SDK checkouts) lives under
`~/data/dart-analyzer-perf` (override with `DART_ANALYZER_PERF_DATA`).

## License

MIT, see `LICENSE`. The patched copies of `analysis_server_plugin` produced by the probe
builder keep their original BSD license from the Dart project.
