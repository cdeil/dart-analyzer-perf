import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_62.dart';
import 'package:core/src/repositories/repository_62.dart';

final repository142Provider = Provider<Repository62>(
  (ref) => Repository62(142),
  isAutoDispose: !false,
);

/// Items notifier 142: loads and edits [Model62] values.
class Items142Notifier extends AsyncNotifier<List<Model62>> {
  @override
  FutureOr<List<Model62>> build() async {
    final repository = ref.watch(repository142Provider);
    return repository.list();
  }

  Future<void> add(Model62 item) async {
    final repository = ref.read(repository142Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository142Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items142Provider =
    AsyncNotifierProvider<Items142Notifier, List<Model62>>(
  Items142Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 142: tracks the selected item id.
class Selection142Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection142Provider =
    NotifierProvider<Selection142Notifier, String?>(
  Selection142Notifier.new,
  isAutoDispose: !false,
);

final selectedItem142Provider = Provider<Model62?>((ref) {
  final id = ref.watch(selection142Provider);
  final items = ref.watch(items142Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
