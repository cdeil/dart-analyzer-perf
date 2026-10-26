"""Run the in-process plugin probe against a project and record phase timings.

Examples:
  python3 bench/plugin_probe/probe_run.py --project fixtures/riverpod_workspace --label as-shipped
  python3 bench/plugin_probe/probe_run.py --project fixtures/riverpod_workspace --label nofine-store \
      --env PROBE_FINE_DEPS=0 --store nofine --fresh-store --repeat 3

The first repetition with --fresh-store is a cold run; later repetitions are warm.
"""
import argparse
import json
import os
import resource
import shutil
import subprocess
import time
from pathlib import Path

DATA = Path(os.environ.get('DART_ANALYZER_PERF_DATA', Path.home() / 'data/dart-analyzer-perf'))


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('--project', required=True)
    p.add_argument('--label', required=True)
    p.add_argument('--sdk', default=os.environ.get('DART_SDK', ''), help='Dart SDK directory (contains bin/dartaotruntime)')
    p.add_argument('--harness', default='default')
    p.add_argument('--store', default='', help='name of a persistent probe byte store directory')
    p.add_argument('--fresh-store', action='store_true')
    p.add_argument('--env', action='append', default=[])
    p.add_argument('--repeat', type=int, default=1)
    p.add_argument('--results', default='results/plugin_probe.jsonl')
    a = p.parse_args()
    sdk = Path(a.sdk) if a.sdk else Path(shutil.which('dart')).resolve().parent.parent
    aot = DATA / 'harness' / a.harness / 'probe.aot'
    logs = DATA / 'probe-logs'
    logs.mkdir(parents=True, exist_ok=True)
    root = Path(a.project).resolve()
    for i in range(1, a.repeat + 1):
        env = dict(os.environ)
        env.update(dict(e.split('=', 1) for e in a.env))
        store = ''
        if a.store:
            store_dir = DATA / 'states' / f'probe-store-{a.store}'
            if a.fresh_store and i == 1 and store_dir.exists():
                shutil.rmtree(store_dir)
            store_dir.mkdir(parents=True, exist_ok=True)
            store = str(store_dir)
            env['PROBE_BYTE_STORE'] = store
        label = f'{a.label}-{i}'
        cmd = [str(sdk / 'bin/dartaotruntime'), str(aot), str(root), str(sdk), store or '/nonexistent']
        before = resource.getrusage(resource.RUSAGE_CHILDREN)
        start = time.perf_counter()
        proc = subprocess.run(cmd, env=env, cwd=aot.parent, capture_output=True, text=True)
        wall = time.perf_counter() - start
        after = resource.getrusage(resource.RUSAGE_CHILDREN)
        (logs / f'{label}.stdout').write_text(proc.stdout)
        (logs / f'{label}.stderr').write_text(proc.stderr)
        result_line = next((l for l in proc.stdout.splitlines() if l.startswith('[probe-result]')), '')
        findings = sorted(l for l in proc.stdout.splitlines() if l.startswith(('error - ', 'warning - ', 'info - ')))
        probe_lines = [l for l in proc.stderr.splitlines() if l.startswith('[probe]') and 'performance tree' not in l]
        row = {
            'label': label, 'env': {k: v for k, v in env.items() if k.startswith('PROBE_')}, 'store': store,
            'exit': proc.returncode, 'wall_s': round(wall, 3),
            'user_s': round(after.ru_utime - before.ru_utime, 3), 'system_s': round(after.ru_stime - before.ru_stime, 3),
            'maxrss_mb': round(after.ru_maxrss / 1e6, 1), 'result': result_line, 'finding_count': len(findings),
            'findings': findings, 'probe_lines': probe_lines, 'time': time.strftime('%Y-%m-%dT%H:%M:%S'),
        }
        results = Path(a.results)
        results.parent.mkdir(parents=True, exist_ok=True)
        with results.open('a') as out:
            out.write(json.dumps(row) + '\n')
        print(json.dumps({k: row[k] for k in ['label', 'exit', 'wall_s', 'user_s', 'system_s', 'maxrss_mb', 'finding_count', 'result']}), flush=True)
        if proc.returncode != 0:
            print(proc.stderr[-3000:])


if __name__ == '__main__':
    main()
