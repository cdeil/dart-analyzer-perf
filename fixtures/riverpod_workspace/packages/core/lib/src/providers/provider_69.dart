import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_69.dart';
import 'package:core/src/repositories/repository_69.dart';

final repository69Provider = Provider<Repository69>(
  (ref) => Repository69(69),
  isAutoDispose: !false,
);

/// Items notifier 69: loads and edits [Model69] values.
class Items69Notifier extends AsyncNotifier<List<Model69>> {
  @override
  FutureOr<List<Model69>> build() async {
    final repository = ref.watch(repository69Provider);
    return repository.list();
  }

  Future<void> add(Model69 item) async {
    final repository = ref.read(repository69Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository69Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items69Provider =
    AsyncNotifierProvider<Items69Notifier, List<Model69>>(
  Items69Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 69: tracks the selected item id.
class Selection69Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection69Provider =
    NotifierProvider<Selection69Notifier, String?>(
  Selection69Notifier.new,
  isAutoDispose: !false,
);

final selectedItem69Provider = Provider<Model69?>((ref) {
  final id = ref.watch(selection69Provider);
  final items = ref.watch(items69Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
