import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_44.dart';
import 'package:core/src/repositories/repository_44.dart';

final repository124Provider = Provider<Repository44>(
  (ref) => Repository44(124),
  isAutoDispose: !false,
);

/// Items notifier 124: loads and edits [Model44] values.
class Items124Notifier extends AsyncNotifier<List<Model44>> {
  @override
  FutureOr<List<Model44>> build() async {
    final repository = ref.watch(repository124Provider);
    return repository.list();
  }

  Future<void> add(Model44 item) async {
    final repository = ref.read(repository124Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository124Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items124Provider =
    AsyncNotifierProvider<Items124Notifier, List<Model44>>(
  Items124Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 124: tracks the selected item id.
class Selection124Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection124Provider =
    NotifierProvider<Selection124Notifier, String?>(
  Selection124Notifier.new,
  isAutoDispose: !false,
);

final selectedItem124Provider = Provider<Model44?>((ref) {
  final id = ref.watch(selection124Provider);
  final items = ref.watch(items124Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
