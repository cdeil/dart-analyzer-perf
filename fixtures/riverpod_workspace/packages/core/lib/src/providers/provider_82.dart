import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_2.dart';
import 'package:core/src/repositories/repository_2.dart';

final repository82Provider = Provider<Repository2>(
  (ref) => Repository2(82),
  isAutoDispose: !false,
);

/// Items notifier 82: loads and edits [Model2] values.
class Items82Notifier extends AsyncNotifier<List<Model2>> {
  @override
  FutureOr<List<Model2>> build() async {
    final repository = ref.watch(repository82Provider);
    return repository.list();
  }

  Future<void> add(Model2 item) async {
    final repository = ref.read(repository82Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository82Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items82Provider =
    AsyncNotifierProvider<Items82Notifier, List<Model2>>(
  Items82Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 82: tracks the selected item id.
class Selection82Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection82Provider =
    NotifierProvider<Selection82Notifier, String?>(
  Selection82Notifier.new,
  isAutoDispose: !false,
);

final selectedItem82Provider = Provider<Model2?>((ref) {
  final id = ref.watch(selection82Provider);
  final items = ref.watch(items82Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
