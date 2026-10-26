import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_34.dart';
import 'package:core/src/repositories/repository_74.dart';

final repository154Provider = Provider<Repository74>(
  (ref) => Repository74(154),
  isAutoDispose: !false,
);

/// Items notifier 154: loads and edits [Model34] values.
class Items154Notifier extends AsyncNotifier<List<Model34>> {
  @override
  FutureOr<List<Model34>> build() async {
    final repository = ref.watch(repository154Provider);
    return repository.list();
  }

  Future<void> add(Model34 item) async {
    final repository = ref.read(repository154Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository154Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items154Provider =
    AsyncNotifierProvider<Items154Notifier, List<Model34>>(
  Items154Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 154: tracks the selected item id.
class Selection154Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection154Provider =
    NotifierProvider<Selection154Notifier, String?>(Selection154Notifier.new);

final selectedItem154Provider = Provider<Model34?>((ref) {
  final id = ref.watch(selection154Provider);
  final items = ref.watch(items154Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
