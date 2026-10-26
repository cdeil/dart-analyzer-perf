import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_102.dart';
import 'package:core/src/repositories/repository_22.dart';

final repository102Provider = Provider<Repository22>(
  (ref) => Repository22(102),
  isAutoDispose: !false,
);

/// Items notifier 102: loads and edits [Model102] values.
class Items102Notifier extends AsyncNotifier<List<Model102>> {
  @override
  FutureOr<List<Model102>> build() async {
    final repository = ref.watch(repository102Provider);
    return repository.list();
  }

  Future<void> add(Model102 item) async {
    final repository = ref.read(repository102Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository102Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items102Provider =
    AsyncNotifierProvider<Items102Notifier, List<Model102>>(
  Items102Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 102: tracks the selected item id.
class Selection102Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection102Provider =
    NotifierProvider<Selection102Notifier, String?>(Selection102Notifier.new);

final selectedItem102Provider = Provider<Model102?>((ref) {
  final id = ref.watch(selection102Provider);
  final items = ref.watch(items102Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
