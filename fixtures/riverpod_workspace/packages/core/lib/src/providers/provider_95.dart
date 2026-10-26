import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_95.dart';
import 'package:core/src/repositories/repository_15.dart';

final repository95Provider = Provider<Repository15>(
  (ref) => Repository15(95),
  isAutoDispose: !true,
);

/// Items notifier 95: loads and edits [Model95] values.
class Items95Notifier extends AsyncNotifier<List<Model95>> {
  @override
  FutureOr<List<Model95>> build() async {
    final repository = ref.watch(repository95Provider);
    return repository.list();
  }

  Future<void> add(Model95 item) async {
    final repository = ref.read(repository95Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository95Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items95Provider =
    AsyncNotifierProvider<Items95Notifier, List<Model95>>(
  Items95Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 95: tracks the selected item id.
class Selection95Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection95Provider =
    NotifierProvider<Selection95Notifier, String?>(Selection95Notifier.new);

final selectedItem95Provider = Provider<Model95?>((ref) {
  final id = ref.watch(selection95Provider);
  final items = ref.watch(items95Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
