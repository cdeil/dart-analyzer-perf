import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_26.dart';
import 'package:core/src/repositories/repository_66.dart';

final repository146Provider = Provider<Repository66>(
  (ref) => Repository66(146),
  isAutoDispose: !false,
);

/// Items notifier 146: loads and edits [Model26] values.
class Items146Notifier extends AsyncNotifier<List<Model26>> {
  @override
  FutureOr<List<Model26>> build() async {
    final repository = ref.watch(repository146Provider);
    return repository.list();
  }

  Future<void> add(Model26 item) async {
    final repository = ref.read(repository146Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository146Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items146Provider =
    AsyncNotifierProvider<Items146Notifier, List<Model26>>(
  Items146Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 146: tracks the selected item id.
class Selection146Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection146Provider =
    NotifierProvider<Selection146Notifier, String?>(Selection146Notifier.new);

final selectedItem146Provider = Provider<Model26?>((ref) {
  final id = ref.watch(selection146Provider);
  final items = ref.watch(items146Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
