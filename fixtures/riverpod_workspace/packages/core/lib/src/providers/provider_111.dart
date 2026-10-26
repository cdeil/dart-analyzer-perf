import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_111.dart';
import 'package:core/src/repositories/repository_31.dart';

final repository111Provider = Provider<Repository31>(
  (ref) => Repository31(111),
  isAutoDispose: !false,
);

/// Items notifier 111: loads and edits [Model111] values.
class Items111Notifier extends AsyncNotifier<List<Model111>> {
  @override
  FutureOr<List<Model111>> build() async {
    final repository = ref.watch(repository111Provider);
    return repository.list();
  }

  Future<void> add(Model111 item) async {
    final repository = ref.read(repository111Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository111Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items111Provider =
    AsyncNotifierProvider<Items111Notifier, List<Model111>>(
  Items111Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 111: tracks the selected item id.
class Selection111Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection111Provider =
    NotifierProvider<Selection111Notifier, String?>(Selection111Notifier.new);

final selectedItem111Provider = Provider<Model111?>((ref) {
  final id = ref.watch(selection111Provider);
  final items = ref.watch(items111Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
