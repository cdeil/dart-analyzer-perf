import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_67.dart';
import 'package:core/src/repositories/repository_67.dart';

final repository67Provider = Provider<Repository67>(
  (ref) => Repository67(67),
  isAutoDispose: !false,
);

/// Items notifier 67: loads and edits [Model67] values.
class Items67Notifier extends AsyncNotifier<List<Model67>> {
  @override
  FutureOr<List<Model67>> build() async {
    final repository = ref.watch(repository67Provider);
    return repository.list();
  }

  Future<void> add(Model67 item) async {
    final repository = ref.read(repository67Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository67Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items67Provider =
    AsyncNotifierProvider<Items67Notifier, List<Model67>>(
  Items67Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 67: tracks the selected item id.
class Selection67Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection67Provider =
    NotifierProvider<Selection67Notifier, String?>(
  Selection67Notifier.new,
  isAutoDispose: !false,
);

final selectedItem67Provider = Provider<Model67?>((ref) {
  final id = ref.watch(selection67Provider);
  final items = ref.watch(items67Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
