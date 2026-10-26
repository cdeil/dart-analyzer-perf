import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_104.dart';
import 'package:core/src/repositories/repository_24.dart';

final repository104Provider = Provider<Repository24>(
  (ref) => Repository24(104),
  isAutoDispose: !false,
);

/// Items notifier 104: loads and edits [Model104] values.
class Items104Notifier extends AsyncNotifier<List<Model104>> {
  @override
  FutureOr<List<Model104>> build() async {
    final repository = ref.watch(repository104Provider);
    return repository.list();
  }

  Future<void> add(Model104 item) async {
    final repository = ref.read(repository104Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository104Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items104Provider =
    AsyncNotifierProvider<Items104Notifier, List<Model104>>(
  Items104Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 104: tracks the selected item id.
class Selection104Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection104Provider =
    NotifierProvider<Selection104Notifier, String?>(Selection104Notifier.new);

final selectedItem104Provider = Provider<Model104?>((ref) {
  final id = ref.watch(selection104Provider);
  final items = ref.watch(items104Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
