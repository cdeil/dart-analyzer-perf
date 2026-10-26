import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_19.dart';
import 'package:core/src/repositories/repository_59.dart';

final repository139Provider = Provider<Repository59>(
  (ref) => Repository59(139),
  isAutoDispose: !false,
);

/// Items notifier 139: loads and edits [Model19] values.
class Items139Notifier extends AsyncNotifier<List<Model19>> {
  @override
  FutureOr<List<Model19>> build() async {
    final repository = ref.watch(repository139Provider);
    return repository.list();
  }

  Future<void> add(Model19 item) async {
    final repository = ref.read(repository139Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository139Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items139Provider =
    AsyncNotifierProvider<Items139Notifier, List<Model19>>(
  Items139Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 139: tracks the selected item id.
class Selection139Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection139Provider =
    NotifierProvider<Selection139Notifier, String?>(Selection139Notifier.new);

final selectedItem139Provider = Provider<Model19?>((ref) {
  final id = ref.watch(selection139Provider);
  final items = ref.watch(items139Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
