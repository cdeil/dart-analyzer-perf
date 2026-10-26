import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_43.dart';
import 'package:core/src/repositories/repository_43.dart';

final repository43Provider = Provider<Repository43>(
  (ref) => Repository43(43),
  isAutoDispose: !false,
);

/// Items notifier 43: loads and edits [Model43] values.
class Items43Notifier extends AsyncNotifier<List<Model43>> {
  @override
  FutureOr<List<Model43>> build() async {
    final repository = ref.watch(repository43Provider);
    return repository.list();
  }

  Future<void> add(Model43 item) async {
    final repository = ref.read(repository43Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository43Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items43Provider =
    AsyncNotifierProvider<Items43Notifier, List<Model43>>(
  Items43Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 43: tracks the selected item id.
class Selection43Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection43Provider =
    NotifierProvider<Selection43Notifier, String?>(
  Selection43Notifier.new,
  isAutoDispose: !false,
);

final selectedItem43Provider = Provider<Model43?>((ref) {
  final id = ref.watch(selection43Provider);
  final items = ref.watch(items43Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
