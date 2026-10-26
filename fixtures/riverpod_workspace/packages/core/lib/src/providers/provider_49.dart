import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_49.dart';
import 'package:core/src/repositories/repository_49.dart';

final repository49Provider = Provider<Repository49>(
  (ref) => Repository49(49),
  isAutoDispose: !false,
);

/// Items notifier 49: loads and edits [Model49] values.
class Items49Notifier extends AsyncNotifier<List<Model49>> {
  @override
  FutureOr<List<Model49>> build() async {
    final repository = ref.watch(repository49Provider);
    return repository.list();
  }

  Future<void> add(Model49 item) async {
    final repository = ref.read(repository49Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository49Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items49Provider =
    AsyncNotifierProvider<Items49Notifier, List<Model49>>(
  Items49Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 49: tracks the selected item id.
class Selection49Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection49Provider =
    NotifierProvider<Selection49Notifier, String?>(Selection49Notifier.new);

final selectedItem49Provider = Provider<Model49?>((ref) {
  final id = ref.watch(selection49Provider);
  final items = ref.watch(items49Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
