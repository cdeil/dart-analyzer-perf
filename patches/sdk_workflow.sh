#!/usr/bin/env bash
# Helpers for working on the patches in a gclient-managed Dart SDK checkout.
#
#   patches/sdk_workflow.sh branch <name> <apply-script>   create a branch off origin/main and apply a patch script
#   patches/sdk_workflow.sh test <test-file> [more...]      run SDK package tests with the checkout's prebuilt SDK
#   patches/sdk_workflow.sh format                          dart format the files changed on the current branch
#   patches/sdk_workflow.sh export <name>                   write the branch's diff to patches/<name>/<name>.patch
#
# Environment: DART_SDK_CHECKOUT (default ~/code/oss/dart-sdk/sdk), DEPOT_TOOLS (default
# ~/data/dart-analyzer-perf/depot_tools).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sdk="${DART_SDK_CHECKOUT:-$HOME/code/oss/dart-sdk/sdk}"
export PATH="${DEPOT_TOOLS:-$HOME/data/dart-analyzer-perf/depot_tools}:$PATH"
dart="$sdk/tools/sdks/dart-sdk/bin/dart"

case "${1:-}" in
  branch)
    name="$2"; script="$3"
    cd "$sdk"
    git checkout -q main 2>/dev/null || git checkout -q origin/main
    git new-branch "$name" 2>/dev/null || git checkout -b "$name" --track origin/main
    python3 -I "$here/patches/$script" "$sdk"
    git status --short
    ;;
  test)
    shift
    cd "$sdk"
    for t in "$@"; do
      echo "=== $t"
      "$dart" "$t"
    done
    ;;
  format)
    cd "$sdk"
    git diff --name-only origin/main -- '*.dart' | xargs "$dart" format
    ;;
  export)
    name="$2"
    cd "$sdk"
    mkdir -p "$here/patches/$name"
    git diff origin/main > "$here/patches/$name/$name.patch"
    git log --oneline origin/main..HEAD > "$here/patches/$name/commits.txt"
    echo "wrote $here/patches/$name/$name.patch"
    ;;
  *)
    sed -n 2,12p "$0"
    exit 64
    ;;
esac
