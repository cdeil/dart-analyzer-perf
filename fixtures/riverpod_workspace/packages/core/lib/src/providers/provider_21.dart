import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_21.dart';
import 'package:core/src/repositories/repository_21.dart';

final repository21Provider = Provider<Repository21>(
  (ref) => Repository21(21),
  isAutoDispose: !false,
);

/// Items notifier 21: loads and edits [Model21] values.
class Items21Notifier extends AsyncNotifier<List<Model21>> {
  @override
  FutureOr<List<Model21>> build() async {
    final repository = ref.watch(repository21Provider);
    return repository.list();
  }

  Future<void> add(Model21 item) async {
    final repository = ref.read(repository21Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository21Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items21Provider =
    AsyncNotifierProvider<Items21Notifier, List<Model21>>(
  Items21Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 21: tracks the selected item id.
class Selection21Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection21Provider =
    NotifierProvider<Selection21Notifier, String?>(Selection21Notifier.new);

final selectedItem21Provider = Provider<Model21?>((ref) {
  final id = ref.watch(selection21Provider);
  final items = ref.watch(items21Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
