import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_29.dart';
import 'package:core/src/repositories/repository_29.dart';

final repository29Provider = Provider<Repository29>(
  (ref) => Repository29(29),
  isAutoDispose: !false,
);

/// Items notifier 29: loads and edits [Model29] values.
class Items29Notifier extends AsyncNotifier<List<Model29>> {
  @override
  FutureOr<List<Model29>> build() async {
    final repository = ref.watch(repository29Provider);
    return repository.list();
  }

  Future<void> add(Model29 item) async {
    final repository = ref.read(repository29Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository29Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items29Provider =
    AsyncNotifierProvider<Items29Notifier, List<Model29>>(
  Items29Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 29: tracks the selected item id.
class Selection29Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection29Provider =
    NotifierProvider<Selection29Notifier, String?>(
  Selection29Notifier.new,
  isAutoDispose: !false,
);

final selectedItem29Provider = Provider<Model29?>((ref) {
  final id = ref.watch(selection29Provider);
  final items = ref.watch(items29Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
