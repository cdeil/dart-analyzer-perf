import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_12.dart';
import 'package:core/src/repositories/repository_12.dart';

final repository12Provider = Provider<Repository12>(
  (ref) => Repository12(12),
  isAutoDispose: !false,
);

/// Items notifier 12: loads and edits [Model12] values.
class Items12Notifier extends AsyncNotifier<List<Model12>> {
  @override
  FutureOr<List<Model12>> build() async {
    final repository = ref.watch(repository12Provider);
    return repository.list();
  }

  Future<void> add(Model12 item) async {
    final repository = ref.read(repository12Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository12Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items12Provider =
    AsyncNotifierProvider<Items12Notifier, List<Model12>>(
  Items12Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 12: tracks the selected item id.
class Selection12Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection12Provider =
    NotifierProvider<Selection12Notifier, String?>(Selection12Notifier.new);

final selectedItem12Provider = Provider<Model12?>((ref) {
  final id = ref.watch(selection12Provider);
  final items = ref.watch(items12Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
