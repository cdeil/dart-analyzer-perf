import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_70.dart';
import 'package:core/src/repositories/repository_70.dart';

final repository150Provider = Provider<Repository70>(
  (ref) => Repository70(150),
  isAutoDispose: !true,
);

/// Items notifier 150: loads and edits [Model70] values.
class Items150Notifier extends AsyncNotifier<List<Model70>> {
  @override
  FutureOr<List<Model70>> build() async {
    final repository = ref.watch(repository150Provider);
    return repository.list();
  }

  Future<void> add(Model70 item) async {
    final repository = ref.read(repository150Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository150Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items150Provider =
    AsyncNotifierProvider<Items150Notifier, List<Model70>>(
  Items150Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 150: tracks the selected item id.
class Selection150Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection150Provider =
    NotifierProvider<Selection150Notifier, String?>(
  Selection150Notifier.new,
  isAutoDispose: !true,
);

final selectedItem150Provider = Provider<Model70?>((ref) {
  final id = ref.watch(selection150Provider);
  final items = ref.watch(items150Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
