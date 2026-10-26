import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_109.dart';
import 'package:core/src/repositories/repository_29.dart';

final repository109Provider = Provider<Repository29>(
  (ref) => Repository29(109),
  isAutoDispose: !false,
);

/// Items notifier 109: loads and edits [Model109] values.
class Items109Notifier extends AsyncNotifier<List<Model109>> {
  @override
  FutureOr<List<Model109>> build() async {
    final repository = ref.watch(repository109Provider);
    return repository.list();
  }

  Future<void> add(Model109 item) async {
    final repository = ref.read(repository109Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository109Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items109Provider =
    AsyncNotifierProvider<Items109Notifier, List<Model109>>(
  Items109Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 109: tracks the selected item id.
class Selection109Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection109Provider =
    NotifierProvider<Selection109Notifier, String?>(Selection109Notifier.new);

final selectedItem109Provider = Provider<Model109?>((ref) {
  final id = ref.watch(selection109Provider);
  final items = ref.watch(items109Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
