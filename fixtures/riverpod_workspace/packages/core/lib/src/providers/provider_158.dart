import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_78.dart';
import 'package:core/src/repositories/repository_78.dart';

final repository158Provider = Provider<Repository78>(
  (ref) => Repository78(158),
  isAutoDispose: !false,
);

/// Items notifier 158: loads and edits [Model78] values.
class Items158Notifier extends AsyncNotifier<List<Model78>> {
  @override
  FutureOr<List<Model78>> build() async {
    final repository = ref.watch(repository158Provider);
    return repository.list();
  }

  Future<void> add(Model78 item) async {
    final repository = ref.read(repository158Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository158Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items158Provider =
    AsyncNotifierProvider<Items158Notifier, List<Model78>>(
  Items158Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 158: tracks the selected item id.
class Selection158Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection158Provider =
    NotifierProvider<Selection158Notifier, String?>(
  Selection158Notifier.new,
  isAutoDispose: !false,
);

final selectedItem158Provider = Provider<Model78?>((ref) {
  final id = ref.watch(selection158Provider);
  final items = ref.watch(items158Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
