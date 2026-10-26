import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sentinel: `avoid_public_notifier_properties` must report `publicCounter`.
class SentinelPublicFieldNotifier extends Notifier<int> {
  int publicCounter = 0;

  @override
  int build() => 0;

  void increment() => state = ++publicCounter;
}

final sentinelPublicFieldProvider =
    NotifierProvider<SentinelPublicFieldNotifier, int>(SentinelPublicFieldNotifier.new);
