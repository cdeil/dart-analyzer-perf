import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_91.dart';
import 'package:core/src/repositories/repository_11.dart';

final repository91Provider = Provider<Repository11>(
  (ref) => Repository11(91),
  isAutoDispose: !false,
);

/// Items notifier 91: loads and edits [Model91] values.
class Items91Notifier extends AsyncNotifier<List<Model91>> {
  @override
  FutureOr<List<Model91>> build() async {
    final repository = ref.watch(repository91Provider);
    return repository.list();
  }

  Future<void> add(Model91 item) async {
    final repository = ref.read(repository91Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository91Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items91Provider =
    AsyncNotifierProvider<Items91Notifier, List<Model91>>(
  Items91Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 91: tracks the selected item id.
class Selection91Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection91Provider =
    NotifierProvider<Selection91Notifier, String?>(Selection91Notifier.new);

final selectedItem91Provider = Provider<Model91?>((ref) {
  final id = ref.watch(selection91Provider);
  final items = ref.watch(items91Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
