import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_72.dart';
import 'package:core/src/repositories/repository_72.dart';

final repository152Provider = Provider<Repository72>(
  (ref) => Repository72(152),
  isAutoDispose: !false,
);

/// Items notifier 152: loads and edits [Model72] values.
class Items152Notifier extends AsyncNotifier<List<Model72>> {
  @override
  FutureOr<List<Model72>> build() async {
    final repository = ref.watch(repository152Provider);
    return repository.list();
  }

  Future<void> add(Model72 item) async {
    final repository = ref.read(repository152Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository152Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items152Provider =
    AsyncNotifierProvider<Items152Notifier, List<Model72>>(
  Items152Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 152: tracks the selected item id.
class Selection152Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection152Provider =
    NotifierProvider<Selection152Notifier, String?>(
  Selection152Notifier.new,
  isAutoDispose: !false,
);

final selectedItem152Provider = Provider<Model72?>((ref) {
  final id = ref.watch(selection152Provider);
  final items = ref.watch(items152Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
