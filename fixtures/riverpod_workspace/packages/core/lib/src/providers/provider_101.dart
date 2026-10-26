import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_101.dart';
import 'package:core/src/repositories/repository_21.dart';

final repository101Provider = Provider<Repository21>(
  (ref) => Repository21(101),
  isAutoDispose: !false,
);

/// Items notifier 101: loads and edits [Model101] values.
class Items101Notifier extends AsyncNotifier<List<Model101>> {
  @override
  FutureOr<List<Model101>> build() async {
    final repository = ref.watch(repository101Provider);
    return repository.list();
  }

  Future<void> add(Model101 item) async {
    final repository = ref.read(repository101Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository101Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items101Provider =
    AsyncNotifierProvider<Items101Notifier, List<Model101>>(
  Items101Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 101: tracks the selected item id.
class Selection101Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection101Provider =
    NotifierProvider<Selection101Notifier, String?>(Selection101Notifier.new);

final selectedItem101Provider = Provider<Model101?>((ref) {
  final id = ref.watch(selection101Provider);
  final items = ref.watch(items101Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
