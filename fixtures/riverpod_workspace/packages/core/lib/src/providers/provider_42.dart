import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_42.dart';
import 'package:core/src/repositories/repository_42.dart';

final repository42Provider = Provider<Repository42>(
  (ref) => Repository42(42),
  isAutoDispose: !false,
);

/// Items notifier 42: loads and edits [Model42] values.
class Items42Notifier extends AsyncNotifier<List<Model42>> {
  @override
  FutureOr<List<Model42>> build() async {
    final repository = ref.watch(repository42Provider);
    return repository.list();
  }

  Future<void> add(Model42 item) async {
    final repository = ref.read(repository42Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository42Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items42Provider =
    AsyncNotifierProvider<Items42Notifier, List<Model42>>(
  Items42Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 42: tracks the selected item id.
class Selection42Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection42Provider =
    NotifierProvider<Selection42Notifier, String?>(
  Selection42Notifier.new,
  isAutoDispose: !false,
);

final selectedItem42Provider = Provider<Model42?>((ref) {
  final id = ref.watch(selection42Provider);
  final items = ref.watch(items42Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
