import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_62.dart';
import 'package:core/src/repositories/repository_62.dart';

final repository62Provider = Provider<Repository62>(
  (ref) => Repository62(62),
  isAutoDispose: !false,
);

/// Items notifier 62: loads and edits [Model62] values.
class Items62Notifier extends AsyncNotifier<List<Model62>> {
  @override
  FutureOr<List<Model62>> build() async {
    final repository = ref.watch(repository62Provider);
    return repository.list();
  }

  Future<void> add(Model62 item) async {
    final repository = ref.read(repository62Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository62Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items62Provider =
    AsyncNotifierProvider<Items62Notifier, List<Model62>>(
  Items62Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 62: tracks the selected item id.
class Selection62Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection62Provider =
    NotifierProvider<Selection62Notifier, String?>(
  Selection62Notifier.new,
  isAutoDispose: !false,
);

final selectedItem62Provider = Provider<Model62?>((ref) {
  final id = ref.watch(selection62Provider);
  final items = ref.watch(items62Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
