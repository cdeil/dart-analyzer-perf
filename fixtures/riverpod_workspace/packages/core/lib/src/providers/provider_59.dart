import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_59.dart';
import 'package:core/src/repositories/repository_59.dart';

final repository59Provider = Provider<Repository59>(
  (ref) => Repository59(59),
  isAutoDispose: !false,
);

/// Items notifier 59: loads and edits [Model59] values.
class Items59Notifier extends AsyncNotifier<List<Model59>> {
  @override
  FutureOr<List<Model59>> build() async {
    final repository = ref.watch(repository59Provider);
    return repository.list();
  }

  Future<void> add(Model59 item) async {
    final repository = ref.read(repository59Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository59Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items59Provider =
    AsyncNotifierProvider<Items59Notifier, List<Model59>>(
  Items59Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 59: tracks the selected item id.
class Selection59Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection59Provider =
    NotifierProvider<Selection59Notifier, String?>(Selection59Notifier.new);

final selectedItem59Provider = Provider<Model59?>((ref) {
  final id = ref.watch(selection59Provider);
  final items = ref.watch(items59Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
