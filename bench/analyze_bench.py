"""Time complete `dart analyze --fatal-infos` runs with controlled analyzer state.

Each run records wall time, CPU time of the whole process tree, exit code and the sorted
diagnostic identities, so that runs can be compared for speed and for parity.

Examples:
  python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label plugin-warm --repeat 3
  python3 bench/analyze_bench.py --project fixtures/riverpod_workspace --label noplugin-cold --no-plugins --fresh-state --repeat 2

State directories live under --state-root (default ~/data/dart-analyzer-perf/states) so that
the user's own ~/.dartServer cache is never touched. `--fresh-state` empties the analyzer's
semantic cache (.analysis-driver) before each run but keeps the compiled plugin; `--fresh-all`
also discards the compiled plugin.
"""
import argparse
import json
import os
import re
import resource
import shutil
import subprocess
import time
from pathlib import Path

DEFAULT_STATE_ROOT = Path(os.environ.get('DART_ANALYZER_PERF_DATA', Path.home() / 'data/dart-analyzer-perf')) / 'states'


def run(label, cmd, cwd, state, results, logs, extra_env=None):
    logs.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, CI='true', FLUTTER_SUPPRESS_ANALYTICS='true')
    state.mkdir(parents=True, exist_ok=True)
    env['ANALYZER_STATE_LOCATION_OVERRIDE'] = str(state)
    if extra_env:
        env.update(extra_env)
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    start = time.perf_counter()
    log = logs / f'{label}.log'
    with log.open('w') as out:
        proc = subprocess.run(cmd, cwd=cwd, env=env, stdout=out, stderr=subprocess.STDOUT)
    wall = time.perf_counter() - start
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    text = log.read_text(errors='replace')
    findings = sorted(l.strip() for l in text.splitlines() if re.match(r'\s*(error|warning|info) - ', l))
    summary = [l.strip() for l in text.splitlines() if re.search(r'issues? found|No issues found', l)]
    row = {
        'label': label, 'cmd': cmd, 'cwd': str(cwd), 'state': str(state), 'exit': proc.returncode,
        'wall_s': round(wall, 3), 'user_s': round(after.ru_utime - before.ru_utime, 3),
        'system_s': round(after.ru_stime - before.ru_stime, 3),
        'finding_count': len(findings), 'findings': findings, 'summary': summary, 'log': str(log),
        'time': time.strftime('%Y-%m-%dT%H:%M:%S'),
    }
    results.parent.mkdir(parents=True, exist_ok=True)
    with results.open('a') as out:
        out.write(json.dumps(row) + '\n')
    print(json.dumps({k: row[k] for k in ['label', 'exit', 'wall_s', 'user_s', 'system_s', 'finding_count', 'summary']}), flush=True)
    return row


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('--project', required=True, help='workspace or package root to analyze')
    p.add_argument('--label', required=True)
    p.add_argument('--dart', default=os.environ.get('DART_BIN', 'dart'), help='dart executable (e.g. the fvm pinned one)')
    p.add_argument('--state', default='main', help='name of the analyzer state directory under --state-root')
    p.add_argument('--state-root', default=str(DEFAULT_STATE_ROOT))
    p.add_argument('--results', default='results/analyze_bench.jsonl')
    p.add_argument('--logs', default=None, help='log directory (default: <state-root>/../logs)')
    p.add_argument('--repeat', type=int, default=1)
    p.add_argument('--no-plugins', action='store_true')
    p.add_argument('--fresh-state', action='store_true')
    p.add_argument('--fresh-all', action='store_true')
    p.add_argument('--env', action='append', default=[], help='extra VAR=value for the analyzer process')
    a = p.parse_args()
    state_root = Path(a.state_root)
    logs = Path(a.logs) if a.logs else state_root.parent / 'logs'
    cmd = [a.dart, 'analyze', '--fatal-infos'] + (['--no-plugins'] if a.no_plugins else [])
    extra = dict(e.split('=', 1) for e in a.env)
    for i in range(1, a.repeat + 1):
        state = state_root / a.state
        if a.fresh_all and state.exists():
            shutil.rmtree(state)
        if a.fresh_state and (state / '.analysis-driver').exists():
            shutil.rmtree(state / '.analysis-driver')
        run(f'{a.label}-{i}', cmd, Path(a.project).resolve(), state, Path(a.results), logs, extra)


if __name__ == '__main__':
    main()
