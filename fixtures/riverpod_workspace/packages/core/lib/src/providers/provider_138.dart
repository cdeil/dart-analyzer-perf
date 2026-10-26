import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_18.dart';
import 'package:core/src/repositories/repository_58.dart';

final repository138Provider = Provider<Repository58>(
  (ref) => Repository58(138),
  isAutoDispose: !false,
);

/// Items notifier 138: loads and edits [Model18] values.
class Items138Notifier extends AsyncNotifier<List<Model18>> {
  @override
  FutureOr<List<Model18>> build() async {
    final repository = ref.watch(repository138Provider);
    return repository.list();
  }

  Future<void> add(Model18 item) async {
    final repository = ref.read(repository138Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository138Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items138Provider =
    AsyncNotifierProvider<Items138Notifier, List<Model18>>(
  Items138Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 138: tracks the selected item id.
class Selection138Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection138Provider =
    NotifierProvider<Selection138Notifier, String?>(Selection138Notifier.new);

final selectedItem138Provider = Provider<Model18?>((ref) {
  final id = ref.watch(selection138Provider);
  final items = ref.watch(items138Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
