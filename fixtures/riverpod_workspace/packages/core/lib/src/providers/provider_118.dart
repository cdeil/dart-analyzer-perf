import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_118.dart';
import 'package:core/src/repositories/repository_38.dart';

final repository118Provider = Provider<Repository38>(
  (ref) => Repository38(118),
  isAutoDispose: !false,
);

/// Items notifier 118: loads and edits [Model118] values.
class Items118Notifier extends AsyncNotifier<List<Model118>> {
  @override
  FutureOr<List<Model118>> build() async {
    final repository = ref.watch(repository118Provider);
    return repository.list();
  }

  Future<void> add(Model118 item) async {
    final repository = ref.read(repository118Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository118Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items118Provider =
    AsyncNotifierProvider<Items118Notifier, List<Model118>>(
  Items118Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 118: tracks the selected item id.
class Selection118Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection118Provider =
    NotifierProvider<Selection118Notifier, String?>(Selection118Notifier.new);

final selectedItem118Provider = Provider<Model118?>((ref) {
  final id = ref.watch(selection118Provider);
  final items = ref.watch(items118Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
