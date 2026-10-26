import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

/// Sentinel: `avoid_ref_inside_state_dispose` must report the `ref.read` in dispose.
class SentinelDisposeScreen extends ConsumerStatefulWidget {
  const SentinelDisposeScreen({super.key});

  @override
  ConsumerState<SentinelDisposeScreen> createState() => _SentinelDisposeScreenState();
}

class _SentinelDisposeScreenState extends ConsumerState<SentinelDisposeScreen> {
  @override
  void dispose() {
    ref.read(selection0Provider.notifier).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const ItemsList0();
}
