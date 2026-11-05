# Draft comment for dart-lang/sdk#63244 (plugin compiled per consumer)

Status: prefilled in Chrome for review (5 November 2026).

---

Another case of the same cost: git worktrees. Every worktree of a project is a new context
root path, so it gets its own `.plugin_manager` folder, its own `pub get` and its own AOT
compile of an identical plugin package. With `riverpod_lint` 3.1.9 the compile alone takes
about 12 s (Apple M5 Pro, Dart 3.13.7), on top of the `pub get`; one machine here had
accumulated 70 such folders (1.0 GB).

Since https://dart-review.googlesource.com/c/sdk/+/569682 the folder name is
`<context root>_<hash of the generated pubspec>`, and the snapshot is now published by
rename (https://dart-review.googlesource.com/c/sdk/+/569480). Would it be acceptable to drop
the context root from the name, so that context roots with the same generated pubspec share
one package? The pubspec already contains every plugin source (including absolute `path:`
sources) and the dependency overrides, and the manager adds the SDK version. The part I am
not sure about is two servers running `pub get` in the same folder at the same time; if that
is the reason for keeping the path, a lock file around `filesFor` might be enough. I can put
together a CL if this direction is welcome.
