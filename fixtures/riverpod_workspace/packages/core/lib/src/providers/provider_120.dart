import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_0.dart';
import 'package:core/src/repositories/repository_40.dart';

final repository120Provider = Provider<Repository40>(
  (ref) => Repository40(120),
  isAutoDispose: !true,
);

/// Items notifier 120: loads and edits [Model0] values.
class Items120Notifier extends AsyncNotifier<List<Model0>> {
  @override
  FutureOr<List<Model0>> build() async {
    final repository = ref.watch(repository120Provider);
    return repository.list();
  }

  Future<void> add(Model0 item) async {
    final repository = ref.read(repository120Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository120Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items120Provider =
    AsyncNotifierProvider<Items120Notifier, List<Model0>>(
  Items120Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 120: tracks the selected item id.
class Selection120Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection120Provider =
    NotifierProvider<Selection120Notifier, String?>(Selection120Notifier.new);

final selectedItem120Provider = Provider<Model0?>((ref) {
  final id = ref.watch(selection120Provider);
  final items = ref.watch(items120Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
