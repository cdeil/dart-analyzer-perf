DART_BIN ?= $(HOME)/fvm/versions/3.47.8/bin/dart
DART_SDK ?= $(HOME)/fvm/versions/3.47.8/bin/cache/dart-sdk
FIXTURE = fixtures/riverpod_workspace
export DART_BIN DART_SDK

.PHONY: fixture bench probe rohd clean-states

fixture:
	python3 fixtures/generate_workspace.py $(FIXTURE)
	cd $(FIXTURE) && $(dir $(DART_BIN))flutter pub get

bench:
	python3 bench/analyze_bench.py --project $(FIXTURE) --label warmup --state main
	python3 bench/analyze_bench.py --project $(FIXTURE) --label plugin-warm --state main --repeat 3
	python3 bench/analyze_bench.py --project $(FIXTURE) --label noplugin-warm --state main --no-plugins --repeat 3
	python3 bench/analyze_bench.py --project $(FIXTURE) --label noplugin-cold --state cold --no-plugins --fresh-all --repeat 2

probe:
	python3 bench/plugin_probe/build_probe.py
	python3 bench/plugin_probe/probe_run.py --project $(FIXTURE) --label as-shipped --repeat 2
	python3 bench/plugin_probe/probe_run.py --project $(FIXTURE) --label nofine --env PROBE_FINE_DEPS=0 --repeat 2
	python3 bench/plugin_probe/probe_run.py --project $(FIXTURE) --label fine-store --store fine --fresh-store --repeat 3
	python3 bench/plugin_probe/probe_run.py --project $(FIXTURE) --label nofine-store --env PROBE_FINE_DEPS=0 --store nofine --fresh-store --repeat 3

rohd:
	bench/rohd_bench.sh 3

clean-states:
	rm -rf $(HOME)/data/dart-analyzer-perf/states
