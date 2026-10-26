import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_68.dart';
import 'package:core/src/repositories/repository_68.dart';

final repository68Provider = Provider<Repository68>(
  (ref) => Repository68(68),
  isAutoDispose: !false,
);

/// Items notifier 68: loads and edits [Model68] values.
class Items68Notifier extends AsyncNotifier<List<Model68>> {
  @override
  FutureOr<List<Model68>> build() async {
    final repository = ref.watch(repository68Provider);
    return repository.list();
  }

  Future<void> add(Model68 item) async {
    final repository = ref.read(repository68Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository68Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items68Provider =
    AsyncNotifierProvider<Items68Notifier, List<Model68>>(
  Items68Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 68: tracks the selected item id.
class Selection68Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection68Provider =
    NotifierProvider<Selection68Notifier, String?>(Selection68Notifier.new);

final selectedItem68Provider = Provider<Model68?>((ref) {
  final id = ref.watch(selection68Provider);
  final items = ref.watch(items68Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
