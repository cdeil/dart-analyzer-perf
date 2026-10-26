import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_105.dart';
import 'package:core/src/repositories/repository_25.dart';

final repository105Provider = Provider<Repository25>(
  (ref) => Repository25(105),
  isAutoDispose: !true,
);

/// Items notifier 105: loads and edits [Model105] values.
class Items105Notifier extends AsyncNotifier<List<Model105>> {
  @override
  FutureOr<List<Model105>> build() async {
    final repository = ref.watch(repository105Provider);
    return repository.list();
  }

  Future<void> add(Model105 item) async {
    final repository = ref.read(repository105Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository105Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items105Provider =
    AsyncNotifierProvider<Items105Notifier, List<Model105>>(
  Items105Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 105: tracks the selected item id.
class Selection105Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection105Provider =
    NotifierProvider<Selection105Notifier, String?>(Selection105Notifier.new);

final selectedItem105Provider = Provider<Model105?>((ref) {
  final id = ref.watch(selection105Provider);
  final items = ref.watch(items105Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
