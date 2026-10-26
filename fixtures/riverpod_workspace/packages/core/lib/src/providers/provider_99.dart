import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_99.dart';
import 'package:core/src/repositories/repository_19.dart';

final repository99Provider = Provider<Repository19>(
  (ref) => Repository19(99),
  isAutoDispose: !false,
);

/// Items notifier 99: loads and edits [Model99] values.
class Items99Notifier extends AsyncNotifier<List<Model99>> {
  @override
  FutureOr<List<Model99>> build() async {
    final repository = ref.watch(repository99Provider);
    return repository.list();
  }

  Future<void> add(Model99 item) async {
    final repository = ref.read(repository99Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository99Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items99Provider =
    AsyncNotifierProvider<Items99Notifier, List<Model99>>(
  Items99Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 99: tracks the selected item id.
class Selection99Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection99Provider =
    NotifierProvider<Selection99Notifier, String?>(Selection99Notifier.new);

final selectedItem99Provider = Provider<Model99?>((ref) {
  final id = ref.watch(selection99Provider);
  final items = ref.watch(items99Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
