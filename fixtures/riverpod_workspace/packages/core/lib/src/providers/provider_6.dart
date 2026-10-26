import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_6.dart';
import 'package:core/src/repositories/repository_6.dart';

final repository6Provider = Provider<Repository6>(
  (ref) => Repository6(6),
  isAutoDispose: !false,
);

/// Items notifier 6: loads and edits [Model6] values.
class Items6Notifier extends AsyncNotifier<List<Model6>> {
  @override
  FutureOr<List<Model6>> build() async {
    final repository = ref.watch(repository6Provider);
    return repository.list();
  }

  Future<void> add(Model6 item) async {
    final repository = ref.read(repository6Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository6Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items6Provider =
    AsyncNotifierProvider<Items6Notifier, List<Model6>>(
  Items6Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 6: tracks the selected item id.
class Selection6Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection6Provider =
    NotifierProvider<Selection6Notifier, String?>(Selection6Notifier.new);

final selectedItem6Provider = Provider<Model6?>((ref) {
  final id = ref.watch(selection6Provider);
  final items = ref.watch(items6Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
