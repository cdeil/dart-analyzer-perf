import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_0.dart';
import 'package:core/src/repositories/repository_0.dart';

final repository0Provider = Provider<Repository0>(
  (ref) => Repository0(0),
  isAutoDispose: !true,
);

/// Items notifier 0: loads and edits [Model0] values.
class Items0Notifier extends AsyncNotifier<List<Model0>> {
  @override
  FutureOr<List<Model0>> build() async {
    final repository = ref.watch(repository0Provider);
    return repository.list();
  }

  Future<void> add(Model0 item) async {
    final repository = ref.read(repository0Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository0Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items0Provider =
    AsyncNotifierProvider<Items0Notifier, List<Model0>>(
  Items0Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 0: tracks the selected item id.
class Selection0Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection0Provider =
    NotifierProvider<Selection0Notifier, String?>(Selection0Notifier.new);

final selectedItem0Provider = Provider<Model0?>((ref) {
  final id = ref.watch(selection0Provider);
  final items = ref.watch(items0Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
