import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_27.dart';
import 'package:core/src/repositories/repository_27.dart';

final repository107Provider = Provider<Repository27>(
  (ref) => Repository27(107),
  isAutoDispose: !false,
);

/// Items notifier 107: loads and edits [Model27] values.
class Items107Notifier extends AsyncNotifier<List<Model27>> {
  @override
  FutureOr<List<Model27>> build() async {
    final repository = ref.watch(repository107Provider);
    return repository.list();
  }

  Future<void> add(Model27 item) async {
    final repository = ref.read(repository107Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository107Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items107Provider =
    AsyncNotifierProvider<Items107Notifier, List<Model27>>(
  Items107Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 107: tracks the selected item id.
class Selection107Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection107Provider =
    NotifierProvider<Selection107Notifier, String?>(
  Selection107Notifier.new,
  isAutoDispose: !false,
);

final selectedItem107Provider = Provider<Model27?>((ref) {
  final id = ref.watch(selection107Provider);
  final items = ref.watch(items107Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
