import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_113.dart';
import 'package:core/src/repositories/repository_33.dart';

final repository113Provider = Provider<Repository33>(
  (ref) => Repository33(113),
  isAutoDispose: !false,
);

/// Items notifier 113: loads and edits [Model113] values.
class Items113Notifier extends AsyncNotifier<List<Model113>> {
  @override
  FutureOr<List<Model113>> build() async {
    final repository = ref.watch(repository113Provider);
    return repository.list();
  }

  Future<void> add(Model113 item) async {
    final repository = ref.read(repository113Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository113Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items113Provider =
    AsyncNotifierProvider<Items113Notifier, List<Model113>>(
  Items113Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 113: tracks the selected item id.
class Selection113Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection113Provider =
    NotifierProvider<Selection113Notifier, String?>(Selection113Notifier.new);

final selectedItem113Provider = Provider<Model113?>((ref) {
  final id = ref.watch(selection113Provider);
  final items = ref.watch(items113Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
