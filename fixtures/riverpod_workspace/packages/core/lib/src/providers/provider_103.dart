import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_103.dart';
import 'package:core/src/repositories/repository_23.dart';

final repository103Provider = Provider<Repository23>(
  (ref) => Repository23(103),
  isAutoDispose: !false,
);

/// Items notifier 103: loads and edits [Model103] values.
class Items103Notifier extends AsyncNotifier<List<Model103>> {
  @override
  FutureOr<List<Model103>> build() async {
    final repository = ref.watch(repository103Provider);
    return repository.list();
  }

  Future<void> add(Model103 item) async {
    final repository = ref.read(repository103Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository103Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items103Provider =
    AsyncNotifierProvider<Items103Notifier, List<Model103>>(
  Items103Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 103: tracks the selected item id.
class Selection103Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection103Provider =
    NotifierProvider<Selection103Notifier, String?>(Selection103Notifier.new);

final selectedItem103Provider = Provider<Model103?>((ref) {
  final id = ref.watch(selection103Provider);
  final items = ref.watch(items103Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
