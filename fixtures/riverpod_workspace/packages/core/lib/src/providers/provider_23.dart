import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_23.dart';
import 'package:core/src/repositories/repository_23.dart';

final repository23Provider = Provider<Repository23>(
  (ref) => Repository23(23),
  isAutoDispose: !false,
);

/// Items notifier 23: loads and edits [Model23] values.
class Items23Notifier extends AsyncNotifier<List<Model23>> {
  @override
  FutureOr<List<Model23>> build() async {
    final repository = ref.watch(repository23Provider);
    return repository.list();
  }

  Future<void> add(Model23 item) async {
    final repository = ref.read(repository23Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository23Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items23Provider =
    AsyncNotifierProvider<Items23Notifier, List<Model23>>(
  Items23Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 23: tracks the selected item id.
class Selection23Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection23Provider =
    NotifierProvider<Selection23Notifier, String?>(Selection23Notifier.new);

final selectedItem23Provider = Provider<Model23?>((ref) {
  final id = ref.watch(selection23Provider);
  final items = ref.watch(items23Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
