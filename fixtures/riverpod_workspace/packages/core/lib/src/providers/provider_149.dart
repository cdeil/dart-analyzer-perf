import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_69.dart';
import 'package:core/src/repositories/repository_69.dart';

final repository149Provider = Provider<Repository69>(
  (ref) => Repository69(149),
  isAutoDispose: !false,
);

/// Items notifier 149: loads and edits [Model69] values.
class Items149Notifier extends AsyncNotifier<List<Model69>> {
  @override
  FutureOr<List<Model69>> build() async {
    final repository = ref.watch(repository149Provider);
    return repository.list();
  }

  Future<void> add(Model69 item) async {
    final repository = ref.read(repository149Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository149Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items149Provider =
    AsyncNotifierProvider<Items149Notifier, List<Model69>>(
  Items149Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 149: tracks the selected item id.
class Selection149Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection149Provider =
    NotifierProvider<Selection149Notifier, String?>(
  Selection149Notifier.new,
  isAutoDispose: !false,
);

final selectedItem149Provider = Provider<Model69?>((ref) {
  final id = ref.watch(selection149Provider);
  final items = ref.watch(items149Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
