#!/usr/bin/env bash
# Run the public ROHD analyzer-plugin reproducer (dart-lang/sdk#63292) with a chosen Dart SDK
# and keep its result next to ours. The reproducer compares a warm native run, an isolated-cache
# native run and a no-op semantic plugin on a 123-file pure-Dart package.
#
# Usage: DART_BIN=$HOME/fvm/versions/3.47.8/bin/dart bench/rohd_bench.sh [iterations]
set -euo pipefail
data="${DART_ANALYZER_PERF_DATA:-$HOME/data/dart-analyzer-perf}"
repo="$data/rohd"
iterations="${1:-3}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ ! -d "$repo" ]; then
  git clone --depth 1 --branch repro/analyzer-plugin-cache-v0.6.10 https://github.com/desmonddak/rohd.git "$repo"
fi
mkdir -p "$here/results/rohd"
out="$here/results/rohd/$(uname -s | tr '[:upper:]' '[:lower:]')-$("${DART_BIN:-dart}" --version 2>&1 | awk '{print $4}').txt"
(cd "$repo" && DART_BIN="${DART_BIN:-dart}" tool/analyzer_plugin_cache_repro/run_benchmark.sh "$iterations" "$out")
echo "result: $out"
