import 'package:flutter_riverpod/flutter_riverpod.dart';

final sentinelAutoDisposeProvider = Provider<int>((ref) => 1);

/// Sentinel: `only_use_keep_alive_inside_keep_alive` must report the keepAlive call.
final sentinelKeepAliveProvider = Provider<int>((ref) {
  ref.watch(sentinelAutoDisposeProvider);
  ref.keepAlive();
  return 2;
});
