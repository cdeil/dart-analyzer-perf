import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_63.dart';
import 'package:core/src/repositories/repository_63.dart';

final repository63Provider = Provider<Repository63>(
  (ref) => Repository63(63),
  isAutoDispose: !false,
);

/// Items notifier 63: loads and edits [Model63] values.
class Items63Notifier extends AsyncNotifier<List<Model63>> {
  @override
  FutureOr<List<Model63>> build() async {
    final repository = ref.watch(repository63Provider);
    return repository.list();
  }

  Future<void> add(Model63 item) async {
    final repository = ref.read(repository63Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository63Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items63Provider =
    AsyncNotifierProvider<Items63Notifier, List<Model63>>(
  Items63Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 63: tracks the selected item id.
class Selection63Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection63Provider =
    NotifierProvider<Selection63Notifier, String?>(
  Selection63Notifier.new,
  isAutoDispose: !false,
);

final selectedItem63Provider = Provider<Model63?>((ref) {
  final id = ref.watch(selection63Provider);
  final items = ref.watch(items63Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
