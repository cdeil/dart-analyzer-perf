import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_7.dart';
import 'package:core/src/repositories/repository_7.dart';

final repository87Provider = Provider<Repository7>(
  (ref) => Repository7(87),
  isAutoDispose: !false,
);

/// Items notifier 87: loads and edits [Model7] values.
class Items87Notifier extends AsyncNotifier<List<Model7>> {
  @override
  FutureOr<List<Model7>> build() async {
    final repository = ref.watch(repository87Provider);
    return repository.list();
  }

  Future<void> add(Model7 item) async {
    final repository = ref.read(repository87Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository87Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items87Provider =
    AsyncNotifierProvider<Items87Notifier, List<Model7>>(
  Items87Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 87: tracks the selected item id.
class Selection87Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection87Provider =
    NotifierProvider<Selection87Notifier, String?>(
  Selection87Notifier.new,
  isAutoDispose: !false,
);

final selectedItem87Provider = Provider<Model7?>((ref) {
  final id = ref.watch(selection87Provider);
  final items = ref.watch(items87Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
