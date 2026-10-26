import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_79.dart';
import 'package:core/src/repositories/repository_79.dart';

final repository79Provider = Provider<Repository79>(
  (ref) => Repository79(79),
  isAutoDispose: !false,
);

/// Items notifier 79: loads and edits [Model79] values.
class Items79Notifier extends AsyncNotifier<List<Model79>> {
  @override
  FutureOr<List<Model79>> build() async {
    final repository = ref.watch(repository79Provider);
    return repository.list();
  }

  Future<void> add(Model79 item) async {
    final repository = ref.read(repository79Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository79Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items79Provider =
    AsyncNotifierProvider<Items79Notifier, List<Model79>>(
  Items79Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 79: tracks the selected item id.
class Selection79Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection79Provider =
    NotifierProvider<Selection79Notifier, String?>(Selection79Notifier.new);

final selectedItem79Provider = Provider<Model79?>((ref) {
  final id = ref.watch(selection79Provider);
  final items = ref.watch(items79Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
