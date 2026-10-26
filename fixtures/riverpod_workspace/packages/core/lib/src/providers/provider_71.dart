import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_71.dart';
import 'package:core/src/repositories/repository_71.dart';

final repository71Provider = Provider<Repository71>(
  (ref) => Repository71(71),
  isAutoDispose: !false,
);

/// Items notifier 71: loads and edits [Model71] values.
class Items71Notifier extends AsyncNotifier<List<Model71>> {
  @override
  FutureOr<List<Model71>> build() async {
    final repository = ref.watch(repository71Provider);
    return repository.list();
  }

  Future<void> add(Model71 item) async {
    final repository = ref.read(repository71Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository71Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items71Provider =
    AsyncNotifierProvider<Items71Notifier, List<Model71>>(
  Items71Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 71: tracks the selected item id.
class Selection71Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection71Provider =
    NotifierProvider<Selection71Notifier, String?>(
  Selection71Notifier.new,
  isAutoDispose: !false,
);

final selectedItem71Provider = Provider<Model71?>((ref) {
  final id = ref.watch(selection71Provider);
  final items = ref.watch(items71Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
