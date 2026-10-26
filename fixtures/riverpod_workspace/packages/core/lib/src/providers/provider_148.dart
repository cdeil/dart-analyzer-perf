import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_68.dart';
import 'package:core/src/repositories/repository_68.dart';

final repository148Provider = Provider<Repository68>(
  (ref) => Repository68(148),
  isAutoDispose: !false,
);

/// Items notifier 148: loads and edits [Model68] values.
class Items148Notifier extends AsyncNotifier<List<Model68>> {
  @override
  FutureOr<List<Model68>> build() async {
    final repository = ref.watch(repository148Provider);
    return repository.list();
  }

  Future<void> add(Model68 item) async {
    final repository = ref.read(repository148Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository148Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items148Provider =
    AsyncNotifierProvider<Items148Notifier, List<Model68>>(
  Items148Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 148: tracks the selected item id.
class Selection148Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection148Provider =
    NotifierProvider<Selection148Notifier, String?>(
  Selection148Notifier.new,
  isAutoDispose: !false,
);

final selectedItem148Provider = Provider<Model68?>((ref) {
  final id = ref.watch(selection148Provider);
  final items = ref.watch(items148Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
