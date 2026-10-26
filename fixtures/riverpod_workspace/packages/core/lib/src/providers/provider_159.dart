import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_39.dart';
import 'package:core/src/repositories/repository_79.dart';

final repository159Provider = Provider<Repository79>(
  (ref) => Repository79(159),
  isAutoDispose: !false,
);

/// Items notifier 159: loads and edits [Model39] values.
class Items159Notifier extends AsyncNotifier<List<Model39>> {
  @override
  FutureOr<List<Model39>> build() async {
    final repository = ref.watch(repository159Provider);
    return repository.list();
  }

  Future<void> add(Model39 item) async {
    final repository = ref.read(repository159Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository159Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items159Provider =
    AsyncNotifierProvider<Items159Notifier, List<Model39>>(
  Items159Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 159: tracks the selected item id.
class Selection159Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection159Provider =
    NotifierProvider<Selection159Notifier, String?>(Selection159Notifier.new);

final selectedItem159Provider = Provider<Model39?>((ref) {
  final id = ref.watch(selection159Provider);
  final items = ref.watch(items159Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
