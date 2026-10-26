import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_13.dart';
import 'package:core/src/repositories/repository_13.dart';

final repository13Provider = Provider<Repository13>(
  (ref) => Repository13(13),
  isAutoDispose: !false,
);

/// Items notifier 13: loads and edits [Model13] values.
class Items13Notifier extends AsyncNotifier<List<Model13>> {
  @override
  FutureOr<List<Model13>> build() async {
    final repository = ref.watch(repository13Provider);
    return repository.list();
  }

  Future<void> add(Model13 item) async {
    final repository = ref.read(repository13Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository13Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items13Provider =
    AsyncNotifierProvider<Items13Notifier, List<Model13>>(
  Items13Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 13: tracks the selected item id.
class Selection13Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection13Provider =
    NotifierProvider<Selection13Notifier, String?>(
  Selection13Notifier.new,
  isAutoDispose: !false,
);

final selectedItem13Provider = Provider<Model13?>((ref) {
  final id = ref.watch(selection13Provider);
  final items = ref.watch(items13Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
