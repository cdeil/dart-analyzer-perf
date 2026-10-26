import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_38.dart';
import 'package:core/src/repositories/repository_38.dart';

final repository38Provider = Provider<Repository38>(
  (ref) => Repository38(38),
  isAutoDispose: !false,
);

/// Items notifier 38: loads and edits [Model38] values.
class Items38Notifier extends AsyncNotifier<List<Model38>> {
  @override
  FutureOr<List<Model38>> build() async {
    final repository = ref.watch(repository38Provider);
    return repository.list();
  }

  Future<void> add(Model38 item) async {
    final repository = ref.read(repository38Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository38Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items38Provider =
    AsyncNotifierProvider<Items38Notifier, List<Model38>>(
  Items38Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 38: tracks the selected item id.
class Selection38Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection38Provider =
    NotifierProvider<Selection38Notifier, String?>(Selection38Notifier.new);

final selectedItem38Provider = Provider<Model38?>((ref) {
  final id = ref.watch(selection38Provider);
  final items = ref.watch(items38Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
