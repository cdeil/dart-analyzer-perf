import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_67.dart';
import 'package:core/src/repositories/repository_67.dart';

final repository147Provider = Provider<Repository67>(
  (ref) => Repository67(147),
  isAutoDispose: !false,
);

/// Items notifier 147: loads and edits [Model67] values.
class Items147Notifier extends AsyncNotifier<List<Model67>> {
  @override
  FutureOr<List<Model67>> build() async {
    final repository = ref.watch(repository147Provider);
    return repository.list();
  }

  Future<void> add(Model67 item) async {
    final repository = ref.read(repository147Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository147Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items147Provider =
    AsyncNotifierProvider<Items147Notifier, List<Model67>>(
  Items147Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 147: tracks the selected item id.
class Selection147Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection147Provider =
    NotifierProvider<Selection147Notifier, String?>(
  Selection147Notifier.new,
  isAutoDispose: !false,
);

final selectedItem147Provider = Provider<Model67?>((ref) {
  final id = ref.watch(selection147Provider);
  final items = ref.watch(items147Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
