import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_8.dart';
import 'package:core/src/repositories/repository_8.dart';

final repository8Provider = Provider<Repository8>(
  (ref) => Repository8(8),
  isAutoDispose: !false,
);

/// Items notifier 8: loads and edits [Model8] values.
class Items8Notifier extends AsyncNotifier<List<Model8>> {
  @override
  FutureOr<List<Model8>> build() async {
    final repository = ref.watch(repository8Provider);
    return repository.list();
  }

  Future<void> add(Model8 item) async {
    final repository = ref.read(repository8Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository8Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items8Provider =
    AsyncNotifierProvider<Items8Notifier, List<Model8>>(
  Items8Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 8: tracks the selected item id.
class Selection8Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection8Provider =
    NotifierProvider<Selection8Notifier, String?>(
  Selection8Notifier.new,
  isAutoDispose: !false,
);

final selectedItem8Provider = Provider<Model8?>((ref) {
  final id = ref.watch(selection8Provider);
  final items = ref.watch(items8Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
