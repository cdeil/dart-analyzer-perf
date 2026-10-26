import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_1.dart';
import 'package:core/src/repositories/repository_41.dart';

final repository121Provider = Provider<Repository41>(
  (ref) => Repository41(121),
  isAutoDispose: !false,
);

/// Items notifier 121: loads and edits [Model1] values.
class Items121Notifier extends AsyncNotifier<List<Model1>> {
  @override
  FutureOr<List<Model1>> build() async {
    final repository = ref.watch(repository121Provider);
    return repository.list();
  }

  Future<void> add(Model1 item) async {
    final repository = ref.read(repository121Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository121Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items121Provider =
    AsyncNotifierProvider<Items121Notifier, List<Model1>>(
  Items121Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 121: tracks the selected item id.
class Selection121Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection121Provider =
    NotifierProvider<Selection121Notifier, String?>(Selection121Notifier.new);

final selectedItem121Provider = Provider<Model1?>((ref) {
  final id = ref.watch(selection121Provider);
  final items = ref.watch(items121Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
