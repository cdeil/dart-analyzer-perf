import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_43.dart';
import 'package:core/src/repositories/repository_43.dart';

final repository123Provider = Provider<Repository43>(
  (ref) => Repository43(123),
  isAutoDispose: !false,
);

/// Items notifier 123: loads and edits [Model43] values.
class Items123Notifier extends AsyncNotifier<List<Model43>> {
  @override
  FutureOr<List<Model43>> build() async {
    final repository = ref.watch(repository123Provider);
    return repository.list();
  }

  Future<void> add(Model43 item) async {
    final repository = ref.read(repository123Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository123Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items123Provider =
    AsyncNotifierProvider<Items123Notifier, List<Model43>>(
  Items123Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 123: tracks the selected item id.
class Selection123Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection123Provider =
    NotifierProvider<Selection123Notifier, String?>(
  Selection123Notifier.new,
  isAutoDispose: !false,
);

final selectedItem123Provider = Provider<Model43?>((ref) {
  final id = ref.watch(selection123Provider);
  final items = ref.watch(items123Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
