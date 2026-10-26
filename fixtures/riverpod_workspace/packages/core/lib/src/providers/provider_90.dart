import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_10.dart';
import 'package:core/src/repositories/repository_10.dart';

final repository90Provider = Provider<Repository10>(
  (ref) => Repository10(90),
  isAutoDispose: !true,
);

/// Items notifier 90: loads and edits [Model10] values.
class Items90Notifier extends AsyncNotifier<List<Model10>> {
  @override
  FutureOr<List<Model10>> build() async {
    final repository = ref.watch(repository90Provider);
    return repository.list();
  }

  Future<void> add(Model10 item) async {
    final repository = ref.read(repository90Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository90Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items90Provider =
    AsyncNotifierProvider<Items90Notifier, List<Model10>>(
  Items90Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 90: tracks the selected item id.
class Selection90Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection90Provider =
    NotifierProvider<Selection90Notifier, String?>(
  Selection90Notifier.new,
  isAutoDispose: !true,
);

final selectedItem90Provider = Provider<Model10?>((ref) {
  final id = ref.watch(selection90Provider);
  final items = ref.watch(items90Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
