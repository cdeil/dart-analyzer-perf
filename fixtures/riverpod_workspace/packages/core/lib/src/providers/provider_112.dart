import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_112.dart';
import 'package:core/src/repositories/repository_32.dart';

final repository112Provider = Provider<Repository32>(
  (ref) => Repository32(112),
  isAutoDispose: !false,
);

/// Items notifier 112: loads and edits [Model112] values.
class Items112Notifier extends AsyncNotifier<List<Model112>> {
  @override
  FutureOr<List<Model112>> build() async {
    final repository = ref.watch(repository112Provider);
    return repository.list();
  }

  Future<void> add(Model112 item) async {
    final repository = ref.read(repository112Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository112Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items112Provider =
    AsyncNotifierProvider<Items112Notifier, List<Model112>>(
  Items112Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 112: tracks the selected item id.
class Selection112Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection112Provider =
    NotifierProvider<Selection112Notifier, String?>(Selection112Notifier.new);

final selectedItem112Provider = Provider<Model112?>((ref) {
  final id = ref.watch(selection112Provider);
  final items = ref.watch(items112Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
