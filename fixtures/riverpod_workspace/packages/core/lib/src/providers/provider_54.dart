import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_54.dart';
import 'package:core/src/repositories/repository_54.dart';

final repository54Provider = Provider<Repository54>(
  (ref) => Repository54(54),
  isAutoDispose: !false,
);

/// Items notifier 54: loads and edits [Model54] values.
class Items54Notifier extends AsyncNotifier<List<Model54>> {
  @override
  FutureOr<List<Model54>> build() async {
    final repository = ref.watch(repository54Provider);
    return repository.list();
  }

  Future<void> add(Model54 item) async {
    final repository = ref.read(repository54Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository54Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items54Provider =
    AsyncNotifierProvider<Items54Notifier, List<Model54>>(
  Items54Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 54: tracks the selected item id.
class Selection54Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection54Provider =
    NotifierProvider<Selection54Notifier, String?>(Selection54Notifier.new);

final selectedItem54Provider = Provider<Model54?>((ref) {
  final id = ref.watch(selection54Provider);
  final items = ref.watch(items54Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
