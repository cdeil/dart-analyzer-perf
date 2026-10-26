import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_47.dart';
import 'package:core/src/repositories/repository_47.dart';

final repository47Provider = Provider<Repository47>(
  (ref) => Repository47(47),
  isAutoDispose: !false,
);

/// Items notifier 47: loads and edits [Model47] values.
class Items47Notifier extends AsyncNotifier<List<Model47>> {
  @override
  FutureOr<List<Model47>> build() async {
    final repository = ref.watch(repository47Provider);
    return repository.list();
  }

  Future<void> add(Model47 item) async {
    final repository = ref.read(repository47Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository47Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items47Provider =
    AsyncNotifierProvider<Items47Notifier, List<Model47>>(
  Items47Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 47: tracks the selected item id.
class Selection47Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection47Provider =
    NotifierProvider<Selection47Notifier, String?>(Selection47Notifier.new);

final selectedItem47Provider = Provider<Model47?>((ref) {
  final id = ref.watch(selection47Provider);
  final items = ref.watch(items47Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
