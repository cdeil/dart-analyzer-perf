import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_106.dart';
import 'package:core/src/repositories/repository_26.dart';

final repository106Provider = Provider<Repository26>(
  (ref) => Repository26(106),
  isAutoDispose: !false,
);

/// Items notifier 106: loads and edits [Model106] values.
class Items106Notifier extends AsyncNotifier<List<Model106>> {
  @override
  FutureOr<List<Model106>> build() async {
    final repository = ref.watch(repository106Provider);
    return repository.list();
  }

  Future<void> add(Model106 item) async {
    final repository = ref.read(repository106Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository106Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items106Provider =
    AsyncNotifierProvider<Items106Notifier, List<Model106>>(
  Items106Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 106: tracks the selected item id.
class Selection106Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection106Provider =
    NotifierProvider<Selection106Notifier, String?>(Selection106Notifier.new);

final selectedItem106Provider = Provider<Model106?>((ref) {
  final id = ref.watch(selection106Provider);
  final items = ref.watch(items106Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
