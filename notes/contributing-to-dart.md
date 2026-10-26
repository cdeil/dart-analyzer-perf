# Contributing these changes to the Dart SDK

What the Dart project requires, checked on 26 October 2026 against
[CONTRIBUTING.md](https://github.com/dart-lang/sdk/blob/main/CONTRIBUTING.md), and how this
repository prepares for it.

## Process

- The SDK does not accept GitHub pull requests. Changes go through Gerrit
  (https://dart-review.googlesource.com) with the `depot_tools` workflow: a `gclient`
  checkout (`fetch dart`), a branch per change (`git new-branch`), `git cl upload`.
  A plain `git clone` is explicitly called out as not giving a functional environment.
- The Google Individual Contributor License Agreement must be signed before a change can
  land (it can be signed after upload, before submit). Corporate contributions use the
  corporate CLA; these changes are personal.
- Every change needs two reviewers from the relevant `OWNERS` files;
  `git cl upload --send-mail --r-owners` adds them. The analyzer packages are owned by the
  analyzer team (Konstantin Shcheglov, Brian Wilkerson, Samuel Rawlins and others).
- Descriptions follow the house style: a short imperative title with the package in
  brackets, a paragraph on why, `Bug: https://github.com/dart-lang/sdk/issues/N`, and
  `TEST=` naming the tests that were run.
- Presubmit runs `dart format`, the analyzer on changed packages and the package tests.

## The AI contribution guidelines

Dart's `CONTRIBUTING.md` (section "AI contribution guidelines") and Flutter's
`CONTRIBUTING.ai.md` state the same four requirements, and reviewers are told to close
changes that violate them:

1. Review all AI-generated code before uploading; unmodified output rarely meets the
   standards.
2. Make sure the code compiles and passes at least the tests added by the change.
3. Understand and be able to discuss the code; review feedback cannot be answered by
   pasting it into an agent.
4. Verify every claim in the description and in review comments.

Red flags that get a change closed: a description replaced by generated text, a
description that does not match the diff, stray planning files in the change.

How this repository is organised to meet them:

- Each change is small (tens of lines plus tests) and comes with a measurement and a
  note explaining the mechanism, so the author can read and explain it in full.
- The patch scripts in `patches/` are only a way to reproduce the diff; the uploaded
  change is the reviewed diff on a branch, with nothing else in it.
- `drafts/` are starting points for the author's own words, not text to paste.
- Numbers in descriptions point at `results/` so a reviewer can check them.

## Checklist before each upload

- [ ] Read the whole diff and the test, and be able to explain every line.
- [ ] `tools/sdks/dart-sdk/bin/dart format` on changed files.
- [ ] Package tests pass locally (commands in `patches/README.md`).
- [ ] Description rewritten by hand, numbers verified against `results/`.
- [ ] Bug link and `TEST=` line present; no stray files.
- [ ] Reviewers added from OWNERS.
