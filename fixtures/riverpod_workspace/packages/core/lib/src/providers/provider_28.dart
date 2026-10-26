import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_28.dart';
import 'package:core/src/repositories/repository_28.dart';

final repository28Provider = Provider<Repository28>(
  (ref) => Repository28(28),
  isAutoDispose: !false,
);

/// Items notifier 28: loads and edits [Model28] values.
class Items28Notifier extends AsyncNotifier<List<Model28>> {
  @override
  FutureOr<List<Model28>> build() async {
    final repository = ref.watch(repository28Provider);
    return repository.list();
  }

  Future<void> add(Model28 item) async {
    final repository = ref.read(repository28Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository28Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items28Provider =
    AsyncNotifierProvider<Items28Notifier, List<Model28>>(
  Items28Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 28: tracks the selected item id.
class Selection28Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection28Provider =
    NotifierProvider<Selection28Notifier, String?>(Selection28Notifier.new);

final selectedItem28Provider = Provider<Model28?>((ref) {
  final id = ref.watch(selection28Provider);
  final items = ref.watch(items28Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
