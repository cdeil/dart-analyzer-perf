import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_12.dart';
import 'package:core/src/repositories/repository_52.dart';

final repository132Provider = Provider<Repository52>(
  (ref) => Repository52(132),
  isAutoDispose: !false,
);

/// Items notifier 132: loads and edits [Model12] values.
class Items132Notifier extends AsyncNotifier<List<Model12>> {
  @override
  FutureOr<List<Model12>> build() async {
    final repository = ref.watch(repository132Provider);
    return repository.list();
  }

  Future<void> add(Model12 item) async {
    final repository = ref.read(repository132Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository132Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items132Provider =
    AsyncNotifierProvider<Items132Notifier, List<Model12>>(
  Items132Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 132: tracks the selected item id.
class Selection132Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection132Provider =
    NotifierProvider<Selection132Notifier, String?>(Selection132Notifier.new);

final selectedItem132Provider = Provider<Model12?>((ref) {
  final id = ref.watch(selection132Provider);
  final items = ref.watch(items132Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
