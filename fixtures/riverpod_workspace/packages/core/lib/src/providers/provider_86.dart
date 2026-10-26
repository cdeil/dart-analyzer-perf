import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_6.dart';
import 'package:core/src/repositories/repository_6.dart';

final repository86Provider = Provider<Repository6>(
  (ref) => Repository6(86),
  isAutoDispose: !false,
);

/// Items notifier 86: loads and edits [Model6] values.
class Items86Notifier extends AsyncNotifier<List<Model6>> {
  @override
  FutureOr<List<Model6>> build() async {
    final repository = ref.watch(repository86Provider);
    return repository.list();
  }

  Future<void> add(Model6 item) async {
    final repository = ref.read(repository86Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository86Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items86Provider =
    AsyncNotifierProvider<Items86Notifier, List<Model6>>(
  Items86Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 86: tracks the selected item id.
class Selection86Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection86Provider =
    NotifierProvider<Selection86Notifier, String?>(
  Selection86Notifier.new,
  isAutoDispose: !false,
);

final selectedItem86Provider = Provider<Model6?>((ref) {
  final id = ref.watch(selection86Provider);
  final items = ref.watch(items86Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
