import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_64.dart';
import 'package:core/src/repositories/repository_64.dart';

final repository64Provider = Provider<Repository64>(
  (ref) => Repository64(64),
  isAutoDispose: !false,
);

/// Items notifier 64: loads and edits [Model64] values.
class Items64Notifier extends AsyncNotifier<List<Model64>> {
  @override
  FutureOr<List<Model64>> build() async {
    final repository = ref.watch(repository64Provider);
    return repository.list();
  }

  Future<void> add(Model64 item) async {
    final repository = ref.read(repository64Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository64Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items64Provider =
    AsyncNotifierProvider<Items64Notifier, List<Model64>>(
  Items64Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 64: tracks the selected item id.
class Selection64Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection64Provider =
    NotifierProvider<Selection64Notifier, String?>(
  Selection64Notifier.new,
  isAutoDispose: !false,
);

final selectedItem64Provider = Provider<Model64?>((ref) {
  final id = ref.watch(selection64Provider);
  final items = ref.watch(items64Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
