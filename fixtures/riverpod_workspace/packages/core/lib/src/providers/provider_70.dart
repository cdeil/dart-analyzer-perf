import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_70.dart';
import 'package:core/src/repositories/repository_70.dart';

final repository70Provider = Provider<Repository70>(
  (ref) => Repository70(70),
  isAutoDispose: !true,
);

/// Items notifier 70: loads and edits [Model70] values.
class Items70Notifier extends AsyncNotifier<List<Model70>> {
  @override
  FutureOr<List<Model70>> build() async {
    final repository = ref.watch(repository70Provider);
    return repository.list();
  }

  Future<void> add(Model70 item) async {
    final repository = ref.read(repository70Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository70Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items70Provider =
    AsyncNotifierProvider<Items70Notifier, List<Model70>>(
  Items70Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 70: tracks the selected item id.
class Selection70Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection70Provider =
    NotifierProvider<Selection70Notifier, String?>(Selection70Notifier.new);

final selectedItem70Provider = Provider<Model70?>((ref) {
  final id = ref.watch(selection70Provider);
  final items = ref.watch(items70Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
