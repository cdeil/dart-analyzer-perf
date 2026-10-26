import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_45.dart';
import 'package:core/src/repositories/repository_45.dart';

final repository125Provider = Provider<Repository45>(
  (ref) => Repository45(125),
  isAutoDispose: !true,
);

/// Items notifier 125: loads and edits [Model45] values.
class Items125Notifier extends AsyncNotifier<List<Model45>> {
  @override
  FutureOr<List<Model45>> build() async {
    final repository = ref.watch(repository125Provider);
    return repository.list();
  }

  Future<void> add(Model45 item) async {
    final repository = ref.read(repository125Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository125Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items125Provider =
    AsyncNotifierProvider<Items125Notifier, List<Model45>>(
  Items125Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 125: tracks the selected item id.
class Selection125Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection125Provider =
    NotifierProvider<Selection125Notifier, String?>(
  Selection125Notifier.new,
  isAutoDispose: !true,
);

final selectedItem125Provider = Provider<Model45?>((ref) {
  final id = ref.watch(selection125Provider);
  final items = ref.watch(items125Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
