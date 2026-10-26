import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_30.dart';
import 'package:core/src/repositories/repository_30.dart';

final repository30Provider = Provider<Repository30>(
  (ref) => Repository30(30),
  isAutoDispose: !true,
);

/// Items notifier 30: loads and edits [Model30] values.
class Items30Notifier extends AsyncNotifier<List<Model30>> {
  @override
  FutureOr<List<Model30>> build() async {
    final repository = ref.watch(repository30Provider);
    return repository.list();
  }

  Future<void> add(Model30 item) async {
    final repository = ref.read(repository30Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository30Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items30Provider =
    AsyncNotifierProvider<Items30Notifier, List<Model30>>(
  Items30Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 30: tracks the selected item id.
class Selection30Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection30Provider =
    NotifierProvider<Selection30Notifier, String?>(Selection30Notifier.new);

final selectedItem30Provider = Provider<Model30?>((ref) {
  final id = ref.watch(selection30Provider);
  final items = ref.watch(items30Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
