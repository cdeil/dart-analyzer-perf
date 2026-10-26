import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_9.dart';
import 'package:core/src/repositories/repository_9.dart';

final repository9Provider = Provider<Repository9>(
  (ref) => Repository9(9),
  isAutoDispose: !false,
);

/// Items notifier 9: loads and edits [Model9] values.
class Items9Notifier extends AsyncNotifier<List<Model9>> {
  @override
  FutureOr<List<Model9>> build() async {
    final repository = ref.watch(repository9Provider);
    return repository.list();
  }

  Future<void> add(Model9 item) async {
    final repository = ref.read(repository9Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository9Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items9Provider =
    AsyncNotifierProvider<Items9Notifier, List<Model9>>(
  Items9Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 9: tracks the selected item id.
class Selection9Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection9Provider =
    NotifierProvider<Selection9Notifier, String?>(Selection9Notifier.new);

final selectedItem9Provider = Provider<Model9?>((ref) {
  final id = ref.watch(selection9Provider);
  final items = ref.watch(items9Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
