#!/usr/bin/env bash
# What would an EvictingFileByteStore inside the plugin cost on a large cache directory?
# Warm plugin-probe runs on the fixture with a persistent store, first as is, then with N
# extra files in the store directory, each with a plain FileByteStore and with an
# EvictingFileByteStore (whose constructor scans the directory).
#
# Usage: DART_SDK=$HOME/fvm/versions/3.47.8/bin/cache/dart-sdk bench/plugin_eviction_cost.sh [files]
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
files="${1:-330000}"
data="${DART_ANALYZER_PERF_DATA:-$HOME/data/dart-analyzer-perf}"
run() { python3 "$here/bench/plugin_probe/probe_run.py" --project "$here/fixtures/riverpod_workspace" \
  --store evict --results "$here/results/plugin-eviction-cost.jsonl" "$@"; }
run --label evict-warmup --fresh-store --repeat 3
run --label small-plain --repeat 3
run --label small-evicting --env PROBE_EVICTING=1 --repeat 3
dummy="$data/states/probe-store-evict/zz"
mkdir -p "$dummy"
python3 - "$dummy" "$files" <<'PY'
import os, sys
root, n = sys.argv[1], int(sys.argv[2])
for i in range(n):
    d = os.path.join(root, f'{i % 256:02x}')
    if i < 256:
        os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, f'dummy{i:07d}'), 'wb') as f:
        f.write(b'x' * 1024)
PY
run --label "large-plain-$files" --repeat 3
run --label "large-evicting-$files" --env PROBE_EVICTING=1 --repeat 3
rm -rf "$dummy"
