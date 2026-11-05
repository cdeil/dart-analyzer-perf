#!/usr/bin/env bash
# Does a large analyzer cache directory slow down `dart analyze`?
#
# Runs `dart analyze --no-plugins` on the fixture twice with a warm private state directory,
# then adds N small dummy files to that state's .analysis-driver (the server's
# EvictingFileByteStore scans every file at start-up) and runs it twice more.
#
# Usage: DART_BIN=$HOME/fvm/versions/3.47.8/bin/dart bench/scan_cost.sh [files]
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
files="${1:-330000}"
data="${DART_ANALYZER_PERF_DATA:-$HOME/data/dart-analyzer-perf}"
state=scan-cost
results="$here/results/scan-cost.jsonl"
python3 "$here/bench/analyze_bench.py" --project "$here/fixtures/riverpod_workspace" --label scan-small-warmup \
  --state $state --fresh-all --no-plugins --repeat 1 --results "$results"
python3 "$here/bench/analyze_bench.py" --project "$here/fixtures/riverpod_workspace" --label scan-settle \
  --state $state --no-plugins --repeat 6 --results "$results"
python3 "$here/bench/analyze_bench.py" --project "$here/fixtures/riverpod_workspace" --label scan-small \
  --state $state --no-plugins --repeat 4 --results "$results"
dummy="$data/states/$state/.analysis-driver/zz"
mkdir -p "$dummy"
python3 - "$dummy" "$files" <<'EOF'
import os, sys
root, n = sys.argv[1], int(sys.argv[2])
for i in range(n):
    d = os.path.join(root, f'{i % 256:02x}')
    if i < 256:
        os.makedirs(d, exist_ok=True)
    with open(os.path.join(d, f'dummy{i:07d}'), 'wb') as f:
        f.write(b'x' * 1024)
EOF
echo "dummy files: $(find "$dummy" -type f | wc -l)"
python3 "$here/bench/analyze_bench.py" --project "$here/fixtures/riverpod_workspace" --label "scan-large-$files" \
  --state $state --no-plugins --repeat 4 --results "$results"
rm -rf "$dummy"
python3 "$here/bench/analyze_bench.py" --project "$here/fixtures/riverpod_workspace" --label scan-small-after \
  --state $state --no-plugins --repeat 4 --results "$results"
