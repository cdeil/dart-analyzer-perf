import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_18.dart';
import 'package:core/src/repositories/repository_18.dart';

final repository18Provider = Provider<Repository18>(
  (ref) => Repository18(18),
  isAutoDispose: !false,
);

/// Items notifier 18: loads and edits [Model18] values.
class Items18Notifier extends AsyncNotifier<List<Model18>> {
  @override
  FutureOr<List<Model18>> build() async {
    final repository = ref.watch(repository18Provider);
    return repository.list();
  }

  Future<void> add(Model18 item) async {
    final repository = ref.read(repository18Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository18Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items18Provider =
    AsyncNotifierProvider<Items18Notifier, List<Model18>>(
  Items18Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 18: tracks the selected item id.
class Selection18Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection18Provider =
    NotifierProvider<Selection18Notifier, String?>(Selection18Notifier.new);

final selectedItem18Provider = Provider<Model18?>((ref) {
  final id = ref.watch(selection18Provider);
  final items = ref.watch(items18Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
