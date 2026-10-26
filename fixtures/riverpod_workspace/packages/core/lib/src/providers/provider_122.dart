import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_2.dart';
import 'package:core/src/repositories/repository_42.dart';

final repository122Provider = Provider<Repository42>(
  (ref) => Repository42(122),
  isAutoDispose: !false,
);

/// Items notifier 122: loads and edits [Model2] values.
class Items122Notifier extends AsyncNotifier<List<Model2>> {
  @override
  FutureOr<List<Model2>> build() async {
    final repository = ref.watch(repository122Provider);
    return repository.list();
  }

  Future<void> add(Model2 item) async {
    final repository = ref.read(repository122Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository122Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items122Provider =
    AsyncNotifierProvider<Items122Notifier, List<Model2>>(
  Items122Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 122: tracks the selected item id.
class Selection122Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection122Provider =
    NotifierProvider<Selection122Notifier, String?>(Selection122Notifier.new);

final selectedItem122Provider = Provider<Model2?>((ref) {
  final id = ref.watch(selection122Provider);
  final items = ref.watch(items122Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
