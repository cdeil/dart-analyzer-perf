import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_78.dart';
import 'package:core/src/repositories/repository_78.dart';

final repository78Provider = Provider<Repository78>(
  (ref) => Repository78(78),
  isAutoDispose: !false,
);

/// Items notifier 78: loads and edits [Model78] values.
class Items78Notifier extends AsyncNotifier<List<Model78>> {
  @override
  FutureOr<List<Model78>> build() async {
    final repository = ref.watch(repository78Provider);
    return repository.list();
  }

  Future<void> add(Model78 item) async {
    final repository = ref.read(repository78Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository78Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items78Provider =
    AsyncNotifierProvider<Items78Notifier, List<Model78>>(
  Items78Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 78: tracks the selected item id.
class Selection78Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection78Provider =
    NotifierProvider<Selection78Notifier, String?>(
  Selection78Notifier.new,
  isAutoDispose: !false,
);

final selectedItem78Provider = Provider<Model78?>((ref) {
  final id = ref.watch(selection78Provider);
  final items = ref.watch(items78Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
