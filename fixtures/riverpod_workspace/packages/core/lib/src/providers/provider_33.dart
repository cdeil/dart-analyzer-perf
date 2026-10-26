import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_33.dart';
import 'package:core/src/repositories/repository_33.dart';

final repository33Provider = Provider<Repository33>(
  (ref) => Repository33(33),
  isAutoDispose: !false,
);

/// Items notifier 33: loads and edits [Model33] values.
class Items33Notifier extends AsyncNotifier<List<Model33>> {
  @override
  FutureOr<List<Model33>> build() async {
    final repository = ref.watch(repository33Provider);
    return repository.list();
  }

  Future<void> add(Model33 item) async {
    final repository = ref.read(repository33Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository33Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items33Provider =
    AsyncNotifierProvider<Items33Notifier, List<Model33>>(
  Items33Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 33: tracks the selected item id.
class Selection33Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection33Provider =
    NotifierProvider<Selection33Notifier, String?>(Selection33Notifier.new);

final selectedItem33Provider = Provider<Model33?>((ref) {
  final id = ref.watch(selection33Provider);
  final items = ref.watch(items33Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
