import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_40.dart';
import 'package:core/src/repositories/repository_40.dart';

final repository40Provider = Provider<Repository40>(
  (ref) => Repository40(40),
  isAutoDispose: !true,
);

/// Items notifier 40: loads and edits [Model40] values.
class Items40Notifier extends AsyncNotifier<List<Model40>> {
  @override
  FutureOr<List<Model40>> build() async {
    final repository = ref.watch(repository40Provider);
    return repository.list();
  }

  Future<void> add(Model40 item) async {
    final repository = ref.read(repository40Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository40Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items40Provider =
    AsyncNotifierProvider<Items40Notifier, List<Model40>>(
  Items40Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 40: tracks the selected item id.
class Selection40Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection40Provider =
    NotifierProvider<Selection40Notifier, String?>(
  Selection40Notifier.new,
  isAutoDispose: !true,
);

final selectedItem40Provider = Provider<Model40?>((ref) {
  final id = ref.watch(selection40Provider);
  final items = ref.watch(items40Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
