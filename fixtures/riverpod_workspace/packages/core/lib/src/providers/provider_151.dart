import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_71.dart';
import 'package:core/src/repositories/repository_71.dart';

final repository151Provider = Provider<Repository71>(
  (ref) => Repository71(151),
  isAutoDispose: !false,
);

/// Items notifier 151: loads and edits [Model71] values.
class Items151Notifier extends AsyncNotifier<List<Model71>> {
  @override
  FutureOr<List<Model71>> build() async {
    final repository = ref.watch(repository151Provider);
    return repository.list();
  }

  Future<void> add(Model71 item) async {
    final repository = ref.read(repository151Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository151Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items151Provider =
    AsyncNotifierProvider<Items151Notifier, List<Model71>>(
  Items151Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 151: tracks the selected item id.
class Selection151Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection151Provider =
    NotifierProvider<Selection151Notifier, String?>(
  Selection151Notifier.new,
  isAutoDispose: !false,
);

final selectedItem151Provider = Provider<Model71?>((ref) {
  final id = ref.watch(selection151Provider);
  final items = ref.watch(items151Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
