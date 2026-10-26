import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_8.dart';
import 'package:core/src/repositories/repository_8.dart';

final repository88Provider = Provider<Repository8>(
  (ref) => Repository8(88),
  isAutoDispose: !false,
);

/// Items notifier 88: loads and edits [Model8] values.
class Items88Notifier extends AsyncNotifier<List<Model8>> {
  @override
  FutureOr<List<Model8>> build() async {
    final repository = ref.watch(repository88Provider);
    return repository.list();
  }

  Future<void> add(Model8 item) async {
    final repository = ref.read(repository88Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository88Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items88Provider =
    AsyncNotifierProvider<Items88Notifier, List<Model8>>(
  Items88Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 88: tracks the selected item id.
class Selection88Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection88Provider =
    NotifierProvider<Selection88Notifier, String?>(
  Selection88Notifier.new,
  isAutoDispose: !false,
);

final selectedItem88Provider = Provider<Model8?>((ref) {
  final id = ref.watch(selection88Provider);
  final items = ref.watch(items88Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
