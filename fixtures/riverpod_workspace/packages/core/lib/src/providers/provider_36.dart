import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_36.dart';
import 'package:core/src/repositories/repository_36.dart';

final repository36Provider = Provider<Repository36>(
  (ref) => Repository36(36),
  isAutoDispose: !false,
);

/// Items notifier 36: loads and edits [Model36] values.
class Items36Notifier extends AsyncNotifier<List<Model36>> {
  @override
  FutureOr<List<Model36>> build() async {
    final repository = ref.watch(repository36Provider);
    return repository.list();
  }

  Future<void> add(Model36 item) async {
    final repository = ref.read(repository36Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository36Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items36Provider =
    AsyncNotifierProvider<Items36Notifier, List<Model36>>(
  Items36Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 36: tracks the selected item id.
class Selection36Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection36Provider =
    NotifierProvider<Selection36Notifier, String?>(Selection36Notifier.new);

final selectedItem36Provider = Provider<Model36?>((ref) {
  final id = ref.watch(selection36Provider);
  final items = ref.watch(items36Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
