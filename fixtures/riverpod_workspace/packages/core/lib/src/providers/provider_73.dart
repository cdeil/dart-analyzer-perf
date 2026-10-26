import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_73.dart';
import 'package:core/src/repositories/repository_73.dart';

final repository73Provider = Provider<Repository73>(
  (ref) => Repository73(73),
  isAutoDispose: !false,
);

/// Items notifier 73: loads and edits [Model73] values.
class Items73Notifier extends AsyncNotifier<List<Model73>> {
  @override
  FutureOr<List<Model73>> build() async {
    final repository = ref.watch(repository73Provider);
    return repository.list();
  }

  Future<void> add(Model73 item) async {
    final repository = ref.read(repository73Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository73Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items73Provider =
    AsyncNotifierProvider<Items73Notifier, List<Model73>>(
  Items73Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 73: tracks the selected item id.
class Selection73Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection73Provider =
    NotifierProvider<Selection73Notifier, String?>(
  Selection73Notifier.new,
  isAutoDispose: !false,
);

final selectedItem73Provider = Provider<Model73?>((ref) {
  final id = ref.watch(selection73Provider);
  final items = ref.watch(items73Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
