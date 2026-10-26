import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_21.dart';
import 'package:core/src/repositories/repository_61.dart';

final repository141Provider = Provider<Repository61>(
  (ref) => Repository61(141),
  isAutoDispose: !false,
);

/// Items notifier 141: loads and edits [Model21] values.
class Items141Notifier extends AsyncNotifier<List<Model21>> {
  @override
  FutureOr<List<Model21>> build() async {
    final repository = ref.watch(repository141Provider);
    return repository.list();
  }

  Future<void> add(Model21 item) async {
    final repository = ref.read(repository141Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository141Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items141Provider =
    AsyncNotifierProvider<Items141Notifier, List<Model21>>(
  Items141Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 141: tracks the selected item id.
class Selection141Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection141Provider =
    NotifierProvider<Selection141Notifier, String?>(Selection141Notifier.new);

final selectedItem141Provider = Provider<Model21?>((ref) {
  final id = ref.watch(selection141Provider);
  final items = ref.watch(items141Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
