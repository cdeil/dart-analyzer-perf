# Draft comment for dart-lang/sdk#64202 (persistent ByteStore in analyzer plugins)

Status: READY FOR REVIEW (5 November 2026), prefilled in Chrome. Every number is in
`results/` of this repository or in the October review of the private app. Post this
before uploading the CL.

---

I'd like to help get this landed, and I have measurements for the open eviction question.

Setup: Dart 3.13.7, `riverpod_lint` 3.1.9 (`analysis_server_plugin` 0.3.25, `analyzer` 14.6.0), Apple M5 Pro. The public numbers come from a synthetic Flutter + Riverpod workspace (665 libraries, 3,201-file import closure) in https://github.com/cdeil/dart-analyzer-perf, which also has the scripts; I also measured a private Flutter app (736 libraries, 7,481-file closure).

On the private app, `dart analyze --fatal-infos` takes about 15 s with the plugin and 2.4 s without it. Without the plugin and with an emptied cache it takes 18 s, so the plugin isolate is in effect a second cold analysis on every run. Its driver's `OperationPerformance` tree (12.5–15.7 s in total) shows 4.3 s reading and parsing 6,697 files, 5.4 s linking 3,359 library cycles, 2.6 s computing fine-dependency manifests, 2 s resolving the app's libraries and 0.1 s in the Riverpod rules. All of it is discarded at exit.

With the plugin's memory cache backed by a `FileByteStore` in the directory from `plugin.versionCheck`, as in CL 543560, the diagnostics are identical and later runs of the plugin isolate take 1.6 s instead of 4.4–4.7 s on the public workspace, and 3.0–3.8 s instead of 12.5–15.7 s on the private app.

On eviction: an `EvictingFileByteStore` scans the whole directory when it is created. With 330,000 extra files in the cache directory, about what a busy machine accumulates, the server's own start-up scan already makes a warm `dart analyze --no-plugins` of the public workspace 0.6–0.8 s slower (1.05 s → 1.6–1.85 s). An `EvictingFileByteStore` in the plugin adds a second scan: the plugin isolate goes from 1.64–1.71 s to 1.86–1.92 s. So I'd keep a plain `FileByteStore` in the plugin, as the `EvictingFileByteStore` doc comment says for plugins, and leave eviction to the server, which cleans up at every start and after every 512 MiB it writes. That leaves the case Konstantin described, where only the plugin writes during a long session; there the directory is bounded at the next server start. If you'd rather cover it, I could make the plugin evict as well and let a stamp file skip the start-up scan when a clean-up finished recently, which would also take the 0.6–0.8 s off the server.

@bkonyi, are you still planning to land 543560? If not, I'm happy to upload a version rebased on main, credited to your change, that also flushes pending writes before answering `plugin.shutdown` and adds a test that starts two plugin servers on one store directory and checks that the second one reuses the first one's entries.

Separately, I noticed that every library is resolved twice in the plugin isolate per analysis pass; I'm filing that as its own issue.
