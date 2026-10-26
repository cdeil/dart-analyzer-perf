import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_3.dart';
import 'package:core/src/repositories/repository_3.dart';

final repository83Provider = Provider<Repository3>(
  (ref) => Repository3(83),
  isAutoDispose: !false,
);

/// Items notifier 83: loads and edits [Model3] values.
class Items83Notifier extends AsyncNotifier<List<Model3>> {
  @override
  FutureOr<List<Model3>> build() async {
    final repository = ref.watch(repository83Provider);
    return repository.list();
  }

  Future<void> add(Model3 item) async {
    final repository = ref.read(repository83Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository83Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items83Provider =
    AsyncNotifierProvider<Items83Notifier, List<Model3>>(
  Items83Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 83: tracks the selected item id.
class Selection83Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection83Provider =
    NotifierProvider<Selection83Notifier, String?>(
  Selection83Notifier.new,
  isAutoDispose: !false,
);

final selectedItem83Provider = Provider<Model3?>((ref) {
  final id = ref.watch(selection83Provider);
  final items = ref.watch(items83Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
