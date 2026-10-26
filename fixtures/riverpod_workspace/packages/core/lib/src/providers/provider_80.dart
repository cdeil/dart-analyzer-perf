import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_80.dart';
import 'package:core/src/repositories/repository_0.dart';

final repository80Provider = Provider<Repository0>(
  (ref) => Repository0(80),
  isAutoDispose: !true,
);

/// Items notifier 80: loads and edits [Model80] values.
class Items80Notifier extends AsyncNotifier<List<Model80>> {
  @override
  FutureOr<List<Model80>> build() async {
    final repository = ref.watch(repository80Provider);
    return repository.list();
  }

  Future<void> add(Model80 item) async {
    final repository = ref.read(repository80Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository80Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items80Provider =
    AsyncNotifierProvider<Items80Notifier, List<Model80>>(
  Items80Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 80: tracks the selected item id.
class Selection80Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection80Provider =
    NotifierProvider<Selection80Notifier, String?>(Selection80Notifier.new);

final selectedItem80Provider = Provider<Model80?>((ref) {
  final id = ref.watch(selection80Provider);
  final items = ref.watch(items80Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
