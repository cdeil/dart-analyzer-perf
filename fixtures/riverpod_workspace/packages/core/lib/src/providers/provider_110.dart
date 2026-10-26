import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_30.dart';
import 'package:core/src/repositories/repository_30.dart';

final repository110Provider = Provider<Repository30>(
  (ref) => Repository30(110),
  isAutoDispose: !true,
);

/// Items notifier 110: loads and edits [Model30] values.
class Items110Notifier extends AsyncNotifier<List<Model30>> {
  @override
  FutureOr<List<Model30>> build() async {
    final repository = ref.watch(repository110Provider);
    return repository.list();
  }

  Future<void> add(Model30 item) async {
    final repository = ref.read(repository110Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository110Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items110Provider =
    AsyncNotifierProvider<Items110Notifier, List<Model30>>(
  Items110Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 110: tracks the selected item id.
class Selection110Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection110Provider =
    NotifierProvider<Selection110Notifier, String?>(
  Selection110Notifier.new,
  isAutoDispose: !true,
);

final selectedItem110Provider = Provider<Model30?>((ref) {
  final id = ref.watch(selection110Provider);
  final items = ref.watch(items110Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
