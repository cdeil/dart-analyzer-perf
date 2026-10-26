import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_52.dart';
import 'package:core/src/repositories/repository_52.dart';

final repository52Provider = Provider<Repository52>(
  (ref) => Repository52(52),
  isAutoDispose: !false,
);

/// Items notifier 52: loads and edits [Model52] values.
class Items52Notifier extends AsyncNotifier<List<Model52>> {
  @override
  FutureOr<List<Model52>> build() async {
    final repository = ref.watch(repository52Provider);
    return repository.list();
  }

  Future<void> add(Model52 item) async {
    final repository = ref.read(repository52Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository52Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items52Provider =
    AsyncNotifierProvider<Items52Notifier, List<Model52>>(
  Items52Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 52: tracks the selected item id.
class Selection52Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection52Provider =
    NotifierProvider<Selection52Notifier, String?>(Selection52Notifier.new);

final selectedItem52Provider = Provider<Model52?>((ref) {
  final id = ref.watch(selection52Provider);
  final items = ref.watch(items52Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
