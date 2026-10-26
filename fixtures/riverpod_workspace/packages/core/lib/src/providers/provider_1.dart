import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_1.dart';
import 'package:core/src/repositories/repository_1.dart';

final repository1Provider = Provider<Repository1>(
  (ref) => Repository1(1),
  isAutoDispose: !false,
);

/// Items notifier 1: loads and edits [Model1] values.
class Items1Notifier extends AsyncNotifier<List<Model1>> {
  @override
  FutureOr<List<Model1>> build() async {
    final repository = ref.watch(repository1Provider);
    return repository.list();
  }

  Future<void> add(Model1 item) async {
    final repository = ref.read(repository1Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository1Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items1Provider =
    AsyncNotifierProvider<Items1Notifier, List<Model1>>(
  Items1Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 1: tracks the selected item id.
class Selection1Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection1Provider =
    NotifierProvider<Selection1Notifier, String?>(Selection1Notifier.new);

final selectedItem1Provider = Provider<Model1?>((ref) {
  final id = ref.watch(selection1Provider);
  final items = ref.watch(items1Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
