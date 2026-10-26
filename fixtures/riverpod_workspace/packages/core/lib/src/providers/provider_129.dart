import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_9.dart';
import 'package:core/src/repositories/repository_49.dart';

final repository129Provider = Provider<Repository49>(
  (ref) => Repository49(129),
  isAutoDispose: !false,
);

/// Items notifier 129: loads and edits [Model9] values.
class Items129Notifier extends AsyncNotifier<List<Model9>> {
  @override
  FutureOr<List<Model9>> build() async {
    final repository = ref.watch(repository129Provider);
    return repository.list();
  }

  Future<void> add(Model9 item) async {
    final repository = ref.read(repository129Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository129Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items129Provider =
    AsyncNotifierProvider<Items129Notifier, List<Model9>>(
  Items129Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 129: tracks the selected item id.
class Selection129Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection129Provider =
    NotifierProvider<Selection129Notifier, String?>(Selection129Notifier.new);

final selectedItem129Provider = Provider<Model9?>((ref) {
  final id = ref.watch(selection129Provider);
  final items = ref.watch(items129Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
