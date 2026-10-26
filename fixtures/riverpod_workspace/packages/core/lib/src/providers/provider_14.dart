import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_14.dart';
import 'package:core/src/repositories/repository_14.dart';

final repository14Provider = Provider<Repository14>(
  (ref) => Repository14(14),
  isAutoDispose: !false,
);

/// Items notifier 14: loads and edits [Model14] values.
class Items14Notifier extends AsyncNotifier<List<Model14>> {
  @override
  FutureOr<List<Model14>> build() async {
    final repository = ref.watch(repository14Provider);
    return repository.list();
  }

  Future<void> add(Model14 item) async {
    final repository = ref.read(repository14Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository14Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items14Provider =
    AsyncNotifierProvider<Items14Notifier, List<Model14>>(
  Items14Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 14: tracks the selected item id.
class Selection14Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection14Provider =
    NotifierProvider<Selection14Notifier, String?>(Selection14Notifier.new);

final selectedItem14Provider = Provider<Model14?>((ref) {
  final id = ref.watch(selection14Provider);
  final items = ref.watch(items14Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
