import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_89.dart';
import 'package:core/src/repositories/repository_9.dart';

final repository89Provider = Provider<Repository9>(
  (ref) => Repository9(89),
  isAutoDispose: !false,
);

/// Items notifier 89: loads and edits [Model89] values.
class Items89Notifier extends AsyncNotifier<List<Model89>> {
  @override
  FutureOr<List<Model89>> build() async {
    final repository = ref.watch(repository89Provider);
    return repository.list();
  }

  Future<void> add(Model89 item) async {
    final repository = ref.read(repository89Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository89Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items89Provider =
    AsyncNotifierProvider<Items89Notifier, List<Model89>>(
  Items89Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 89: tracks the selected item id.
class Selection89Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection89Provider =
    NotifierProvider<Selection89Notifier, String?>(Selection89Notifier.new);

final selectedItem89Provider = Provider<Model89?>((ref) {
  final id = ref.watch(selection89Provider);
  final items = ref.watch(items89Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
