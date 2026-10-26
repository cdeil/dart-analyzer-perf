import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_64.dart';
import 'package:core/src/repositories/repository_64.dart';

final repository144Provider = Provider<Repository64>(
  (ref) => Repository64(144),
  isAutoDispose: !false,
);

/// Items notifier 144: loads and edits [Model64] values.
class Items144Notifier extends AsyncNotifier<List<Model64>> {
  @override
  FutureOr<List<Model64>> build() async {
    final repository = ref.watch(repository144Provider);
    return repository.list();
  }

  Future<void> add(Model64 item) async {
    final repository = ref.read(repository144Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository144Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items144Provider =
    AsyncNotifierProvider<Items144Notifier, List<Model64>>(
  Items144Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 144: tracks the selected item id.
class Selection144Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection144Provider =
    NotifierProvider<Selection144Notifier, String?>(
  Selection144Notifier.new,
  isAutoDispose: !false,
);

final selectedItem144Provider = Provider<Model64?>((ref) {
  final id = ref.watch(selection144Provider);
  final items = ref.watch(items144Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
