import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_79.dart';
import 'package:core/src/repositories/repository_79.dart';

final repository159Provider = Provider<Repository79>(
  (ref) => Repository79(159),
  isAutoDispose: !false,
);

/// Items notifier 159: loads and edits [Model79] values.
class Items159Notifier extends AsyncNotifier<List<Model79>> {
  @override
  FutureOr<List<Model79>> build() async {
    final repository = ref.watch(repository159Provider);
    return repository.list();
  }

  Future<void> add(Model79 item) async {
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
    AsyncNotifierProvider<Items159Notifier, List<Model79>>(
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
    NotifierProvider<Selection159Notifier, String?>(
  Selection159Notifier.new,
  isAutoDispose: !false,
);

final selectedItem159Provider = Provider<Model79?>((ref) {
  final id = ref.watch(selection159Provider);
  final items = ref.watch(items159Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
