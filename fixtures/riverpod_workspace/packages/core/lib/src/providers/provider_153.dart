import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_33.dart';
import 'package:core/src/repositories/repository_73.dart';

final repository153Provider = Provider<Repository73>(
  (ref) => Repository73(153),
  isAutoDispose: !false,
);

/// Items notifier 153: loads and edits [Model33] values.
class Items153Notifier extends AsyncNotifier<List<Model33>> {
  @override
  FutureOr<List<Model33>> build() async {
    final repository = ref.watch(repository153Provider);
    return repository.list();
  }

  Future<void> add(Model33 item) async {
    final repository = ref.read(repository153Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository153Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items153Provider =
    AsyncNotifierProvider<Items153Notifier, List<Model33>>(
  Items153Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 153: tracks the selected item id.
class Selection153Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection153Provider =
    NotifierProvider<Selection153Notifier, String?>(Selection153Notifier.new);

final selectedItem153Provider = Provider<Model33?>((ref) {
  final id = ref.watch(selection153Provider);
  final items = ref.watch(items153Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
