import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_39.dart';
import 'package:core/src/repositories/repository_39.dart';

final repository39Provider = Provider<Repository39>(
  (ref) => Repository39(39),
  isAutoDispose: !false,
);

/// Items notifier 39: loads and edits [Model39] values.
class Items39Notifier extends AsyncNotifier<List<Model39>> {
  @override
  FutureOr<List<Model39>> build() async {
    final repository = ref.watch(repository39Provider);
    return repository.list();
  }

  Future<void> add(Model39 item) async {
    final repository = ref.read(repository39Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository39Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items39Provider =
    AsyncNotifierProvider<Items39Notifier, List<Model39>>(
  Items39Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 39: tracks the selected item id.
class Selection39Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection39Provider =
    NotifierProvider<Selection39Notifier, String?>(
  Selection39Notifier.new,
  isAutoDispose: !false,
);

final selectedItem39Provider = Provider<Model39?>((ref) {
  final id = ref.watch(selection39Provider);
  final items = ref.watch(items39Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
