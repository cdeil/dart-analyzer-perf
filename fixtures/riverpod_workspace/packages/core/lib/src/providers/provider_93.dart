import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_93.dart';
import 'package:core/src/repositories/repository_13.dart';

final repository93Provider = Provider<Repository13>(
  (ref) => Repository13(93),
  isAutoDispose: !false,
);

/// Items notifier 93: loads and edits [Model93] values.
class Items93Notifier extends AsyncNotifier<List<Model93>> {
  @override
  FutureOr<List<Model93>> build() async {
    final repository = ref.watch(repository93Provider);
    return repository.list();
  }

  Future<void> add(Model93 item) async {
    final repository = ref.read(repository93Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository93Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items93Provider =
    AsyncNotifierProvider<Items93Notifier, List<Model93>>(
  Items93Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 93: tracks the selected item id.
class Selection93Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection93Provider =
    NotifierProvider<Selection93Notifier, String?>(Selection93Notifier.new);

final selectedItem93Provider = Provider<Model93?>((ref) {
  final id = ref.watch(selection93Provider);
  final items = ref.watch(items93Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
