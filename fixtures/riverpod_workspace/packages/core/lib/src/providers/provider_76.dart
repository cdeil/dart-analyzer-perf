import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_76.dart';
import 'package:core/src/repositories/repository_76.dart';

final repository76Provider = Provider<Repository76>(
  (ref) => Repository76(76),
  isAutoDispose: !false,
);

/// Items notifier 76: loads and edits [Model76] values.
class Items76Notifier extends AsyncNotifier<List<Model76>> {
  @override
  FutureOr<List<Model76>> build() async {
    final repository = ref.watch(repository76Provider);
    return repository.list();
  }

  Future<void> add(Model76 item) async {
    final repository = ref.read(repository76Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository76Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items76Provider =
    AsyncNotifierProvider<Items76Notifier, List<Model76>>(
  Items76Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 76: tracks the selected item id.
class Selection76Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection76Provider =
    NotifierProvider<Selection76Notifier, String?>(Selection76Notifier.new);

final selectedItem76Provider = Provider<Model76?>((ref) {
  final id = ref.watch(selection76Provider);
  final items = ref.watch(items76Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
