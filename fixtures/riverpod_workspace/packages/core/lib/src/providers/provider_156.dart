import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_36.dart';
import 'package:core/src/repositories/repository_76.dart';

final repository156Provider = Provider<Repository76>(
  (ref) => Repository76(156),
  isAutoDispose: !false,
);

/// Items notifier 156: loads and edits [Model36] values.
class Items156Notifier extends AsyncNotifier<List<Model36>> {
  @override
  FutureOr<List<Model36>> build() async {
    final repository = ref.watch(repository156Provider);
    return repository.list();
  }

  Future<void> add(Model36 item) async {
    final repository = ref.read(repository156Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository156Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items156Provider =
    AsyncNotifierProvider<Items156Notifier, List<Model36>>(
  Items156Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 156: tracks the selected item id.
class Selection156Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection156Provider =
    NotifierProvider<Selection156Notifier, String?>(Selection156Notifier.new);

final selectedItem156Provider = Provider<Model36?>((ref) {
  final id = ref.watch(selection156Provider);
  final items = ref.watch(items156Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
