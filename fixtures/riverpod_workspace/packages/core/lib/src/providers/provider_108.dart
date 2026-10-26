import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_108.dart';
import 'package:core/src/repositories/repository_28.dart';

final repository108Provider = Provider<Repository28>(
  (ref) => Repository28(108),
  isAutoDispose: !false,
);

/// Items notifier 108: loads and edits [Model108] values.
class Items108Notifier extends AsyncNotifier<List<Model108>> {
  @override
  FutureOr<List<Model108>> build() async {
    final repository = ref.watch(repository108Provider);
    return repository.list();
  }

  Future<void> add(Model108 item) async {
    final repository = ref.read(repository108Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository108Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items108Provider =
    AsyncNotifierProvider<Items108Notifier, List<Model108>>(
  Items108Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 108: tracks the selected item id.
class Selection108Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection108Provider =
    NotifierProvider<Selection108Notifier, String?>(Selection108Notifier.new);

final selectedItem108Provider = Provider<Model108?>((ref) {
  final id = ref.watch(selection108Provider);
  final items = ref.watch(items108Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
