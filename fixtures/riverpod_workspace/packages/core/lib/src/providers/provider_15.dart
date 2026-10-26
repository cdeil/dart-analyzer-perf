import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_15.dart';
import 'package:core/src/repositories/repository_15.dart';

final repository15Provider = Provider<Repository15>(
  (ref) => Repository15(15),
  isAutoDispose: !true,
);

/// Items notifier 15: loads and edits [Model15] values.
class Items15Notifier extends AsyncNotifier<List<Model15>> {
  @override
  FutureOr<List<Model15>> build() async {
    final repository = ref.watch(repository15Provider);
    return repository.list();
  }

  Future<void> add(Model15 item) async {
    final repository = ref.read(repository15Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository15Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items15Provider =
    AsyncNotifierProvider<Items15Notifier, List<Model15>>(
  Items15Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 15: tracks the selected item id.
class Selection15Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection15Provider =
    NotifierProvider<Selection15Notifier, String?>(Selection15Notifier.new);

final selectedItem15Provider = Provider<Model15?>((ref) {
  final id = ref.watch(selection15Provider);
  final items = ref.watch(items15Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
