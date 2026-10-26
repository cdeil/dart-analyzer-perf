"""Build the in-process plugin probe as an AOT snapshot.

Creates (or refreshes) a harness package under the data directory that depends on the
same `riverpod_lint` version as the fixture and overrides `analysis_server_plugin` with the
patched copy produced by patch_framework.py, then compiles bin/probe.dart to probe.aot with
the same `dart compile aot-snapshot` the analysis server uses for real plugins.

Usage: python3 build_probe.py [--riverpod-lint 3.1.9] [--dart /path/to/dart]
"""
import argparse
import os
import shutil
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = Path(os.environ.get('DART_ANALYZER_PERF_DATA', Path.home() / 'data/dart-analyzer-perf'))


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument('--riverpod-lint', default='3.1.9')
    p.add_argument('--framework-version', default='0.3.25')
    p.add_argument('--dart', default=os.environ.get('DART_BIN', 'dart'))
    p.add_argument('--name', default='default', help='harness variant name under the data directory')
    a = p.parse_args()
    harness = DATA / 'harness' / a.name
    patched = DATA / 'patched' / f'analysis_server_plugin-{a.framework_version}'
    source = Path.home() / f'.pub-cache/hosted/pub.dev/analysis_server_plugin-{a.framework_version}'
    subprocess.run(['python3', '-I', str(HERE / 'patch_framework.py'), '--source', str(source), '--dest', str(patched)], check=True)
    (harness / 'bin').mkdir(parents=True, exist_ok=True)
    shutil.copy(HERE / 'probe.dart', harness / 'bin/probe.dart')
    (harness / 'pubspec.yaml').write_text(f'''name: probe_harness
version: 0.0.1
publish_to: none
environment:
  sdk: ^3.6.0
dependencies:
  analysis_server_plugin: ^0.3.8
  analyzer: any
  analyzer_plugin: any
  path: any
  riverpod_lint: {a.riverpod_lint}
dependency_overrides:
  analysis_server_plugin:
    path: {patched}
''')
    env = dict(os.environ, CI='true')
    subprocess.run([a.dart, 'pub', 'get'], cwd=harness, env=env, check=True)
    subprocess.run([a.dart, 'compile', 'aot-snapshot', 'bin/probe.dart', '-o', 'probe.aot'], cwd=harness, env=env, check=True)
    print('built', harness / 'probe.aot')


if __name__ == '__main__':
    main()
