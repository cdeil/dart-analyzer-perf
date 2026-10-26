import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_26.dart';
import 'package:core/src/repositories/repository_26.dart';

final repository26Provider = Provider<Repository26>(
  (ref) => Repository26(26),
  isAutoDispose: !false,
);

/// Items notifier 26: loads and edits [Model26] values.
class Items26Notifier extends AsyncNotifier<List<Model26>> {
  @override
  FutureOr<List<Model26>> build() async {
    final repository = ref.watch(repository26Provider);
    return repository.list();
  }

  Future<void> add(Model26 item) async {
    final repository = ref.read(repository26Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository26Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items26Provider =
    AsyncNotifierProvider<Items26Notifier, List<Model26>>(
  Items26Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 26: tracks the selected item id.
class Selection26Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection26Provider =
    NotifierProvider<Selection26Notifier, String?>(Selection26Notifier.new);

final selectedItem26Provider = Provider<Model26?>((ref) {
  final id = ref.watch(selection26Provider);
  final items = ref.watch(items26Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
