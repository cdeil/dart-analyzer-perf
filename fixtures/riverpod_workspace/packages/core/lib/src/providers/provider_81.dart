import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_81.dart';
import 'package:core/src/repositories/repository_1.dart';

final repository81Provider = Provider<Repository1>(
  (ref) => Repository1(81),
  isAutoDispose: !false,
);

/// Items notifier 81: loads and edits [Model81] values.
class Items81Notifier extends AsyncNotifier<List<Model81>> {
  @override
  FutureOr<List<Model81>> build() async {
    final repository = ref.watch(repository81Provider);
    return repository.list();
  }

  Future<void> add(Model81 item) async {
    final repository = ref.read(repository81Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository81Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items81Provider =
    AsyncNotifierProvider<Items81Notifier, List<Model81>>(
  Items81Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 81: tracks the selected item id.
class Selection81Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection81Provider =
    NotifierProvider<Selection81Notifier, String?>(Selection81Notifier.new);

final selectedItem81Provider = Provider<Model81?>((ref) {
  final id = ref.watch(selection81Provider);
  final items = ref.watch(items81Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
