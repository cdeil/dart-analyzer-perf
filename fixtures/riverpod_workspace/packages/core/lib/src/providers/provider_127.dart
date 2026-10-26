import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_47.dart';
import 'package:core/src/repositories/repository_47.dart';

final repository127Provider = Provider<Repository47>(
  (ref) => Repository47(127),
  isAutoDispose: !false,
);

/// Items notifier 127: loads and edits [Model47] values.
class Items127Notifier extends AsyncNotifier<List<Model47>> {
  @override
  FutureOr<List<Model47>> build() async {
    final repository = ref.watch(repository127Provider);
    return repository.list();
  }

  Future<void> add(Model47 item) async {
    final repository = ref.read(repository127Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository127Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items127Provider =
    AsyncNotifierProvider<Items127Notifier, List<Model47>>(
  Items127Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 127: tracks the selected item id.
class Selection127Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection127Provider =
    NotifierProvider<Selection127Notifier, String?>(
  Selection127Notifier.new,
  isAutoDispose: !false,
);

final selectedItem127Provider = Provider<Model47?>((ref) {
  final id = ref.watch(selection127Provider);
  final items = ref.watch(items127Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
