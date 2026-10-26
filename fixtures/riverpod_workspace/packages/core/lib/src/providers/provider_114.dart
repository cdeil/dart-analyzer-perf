import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_114.dart';
import 'package:core/src/repositories/repository_34.dart';

final repository114Provider = Provider<Repository34>(
  (ref) => Repository34(114),
  isAutoDispose: !false,
);

/// Items notifier 114: loads and edits [Model114] values.
class Items114Notifier extends AsyncNotifier<List<Model114>> {
  @override
  FutureOr<List<Model114>> build() async {
    final repository = ref.watch(repository114Provider);
    return repository.list();
  }

  Future<void> add(Model114 item) async {
    final repository = ref.read(repository114Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository114Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items114Provider =
    AsyncNotifierProvider<Items114Notifier, List<Model114>>(
  Items114Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 114: tracks the selected item id.
class Selection114Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection114Provider =
    NotifierProvider<Selection114Notifier, String?>(Selection114Notifier.new);

final selectedItem114Provider = Provider<Model114?>((ref) {
  final id = ref.watch(selection114Provider);
  final items = ref.watch(items114Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
