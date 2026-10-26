import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_36.dart';
import 'package:core/src/repositories/repository_36.dart';

final repository116Provider = Provider<Repository36>(
  (ref) => Repository36(116),
  isAutoDispose: !false,
);

/// Items notifier 116: loads and edits [Model36] values.
class Items116Notifier extends AsyncNotifier<List<Model36>> {
  @override
  FutureOr<List<Model36>> build() async {
    final repository = ref.watch(repository116Provider);
    return repository.list();
  }

  Future<void> add(Model36 item) async {
    final repository = ref.read(repository116Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository116Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items116Provider =
    AsyncNotifierProvider<Items116Notifier, List<Model36>>(
  Items116Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 116: tracks the selected item id.
class Selection116Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection116Provider =
    NotifierProvider<Selection116Notifier, String?>(
  Selection116Notifier.new,
  isAutoDispose: !false,
);

final selectedItem116Provider = Provider<Model36?>((ref) {
  final id = ref.watch(selection116Provider);
  final items = ref.watch(items116Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
