import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_100.dart';
import 'package:core/src/repositories/repository_20.dart';

final repository100Provider = Provider<Repository20>(
  (ref) => Repository20(100),
  isAutoDispose: !true,
);

/// Items notifier 100: loads and edits [Model100] values.
class Items100Notifier extends AsyncNotifier<List<Model100>> {
  @override
  FutureOr<List<Model100>> build() async {
    final repository = ref.watch(repository100Provider);
    return repository.list();
  }

  Future<void> add(Model100 item) async {
    final repository = ref.read(repository100Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository100Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items100Provider =
    AsyncNotifierProvider<Items100Notifier, List<Model100>>(
  Items100Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 100: tracks the selected item id.
class Selection100Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection100Provider =
    NotifierProvider<Selection100Notifier, String?>(Selection100Notifier.new);

final selectedItem100Provider = Provider<Model100?>((ref) {
  final id = ref.watch(selection100Provider);
  final items = ref.watch(items100Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
