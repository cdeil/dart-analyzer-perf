import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_34.dart';
import 'package:core/src/repositories/repository_34.dart';

final repository34Provider = Provider<Repository34>(
  (ref) => Repository34(34),
  isAutoDispose: !false,
);

/// Items notifier 34: loads and edits [Model34] values.
class Items34Notifier extends AsyncNotifier<List<Model34>> {
  @override
  FutureOr<List<Model34>> build() async {
    final repository = ref.watch(repository34Provider);
    return repository.list();
  }

  Future<void> add(Model34 item) async {
    final repository = ref.read(repository34Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository34Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items34Provider =
    AsyncNotifierProvider<Items34Notifier, List<Model34>>(
  Items34Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 34: tracks the selected item id.
class Selection34Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection34Provider =
    NotifierProvider<Selection34Notifier, String?>(Selection34Notifier.new);

final selectedItem34Provider = Provider<Model34?>((ref) {
  final id = ref.watch(selection34Provider);
  final items = ref.watch(items34Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
