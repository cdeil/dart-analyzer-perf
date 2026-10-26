import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_74.dart';
import 'package:core/src/repositories/repository_74.dart';

final repository74Provider = Provider<Repository74>(
  (ref) => Repository74(74),
  isAutoDispose: !false,
);

/// Items notifier 74: loads and edits [Model74] values.
class Items74Notifier extends AsyncNotifier<List<Model74>> {
  @override
  FutureOr<List<Model74>> build() async {
    final repository = ref.watch(repository74Provider);
    return repository.list();
  }

  Future<void> add(Model74 item) async {
    final repository = ref.read(repository74Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository74Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items74Provider =
    AsyncNotifierProvider<Items74Notifier, List<Model74>>(
  Items74Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 74: tracks the selected item id.
class Selection74Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection74Provider =
    NotifierProvider<Selection74Notifier, String?>(Selection74Notifier.new);

final selectedItem74Provider = Provider<Model74?>((ref) {
  final id = ref.watch(selection74Provider);
  final items = ref.watch(items74Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
