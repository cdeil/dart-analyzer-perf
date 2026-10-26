import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_22.dart';
import 'package:core/src/repositories/repository_22.dart';

final repository22Provider = Provider<Repository22>(
  (ref) => Repository22(22),
  isAutoDispose: !false,
);

/// Items notifier 22: loads and edits [Model22] values.
class Items22Notifier extends AsyncNotifier<List<Model22>> {
  @override
  FutureOr<List<Model22>> build() async {
    final repository = ref.watch(repository22Provider);
    return repository.list();
  }

  Future<void> add(Model22 item) async {
    final repository = ref.read(repository22Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository22Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items22Provider =
    AsyncNotifierProvider<Items22Notifier, List<Model22>>(
  Items22Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 22: tracks the selected item id.
class Selection22Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection22Provider =
    NotifierProvider<Selection22Notifier, String?>(
  Selection22Notifier.new,
  isAutoDispose: !false,
);

final selectedItem22Provider = Provider<Model22?>((ref) {
  final id = ref.watch(selection22Provider);
  final items = ref.watch(items22Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
