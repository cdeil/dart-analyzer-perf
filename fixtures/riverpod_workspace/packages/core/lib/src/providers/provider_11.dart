import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_11.dart';
import 'package:core/src/repositories/repository_11.dart';

final repository11Provider = Provider<Repository11>(
  (ref) => Repository11(11),
  isAutoDispose: !false,
);

/// Items notifier 11: loads and edits [Model11] values.
class Items11Notifier extends AsyncNotifier<List<Model11>> {
  @override
  FutureOr<List<Model11>> build() async {
    final repository = ref.watch(repository11Provider);
    return repository.list();
  }

  Future<void> add(Model11 item) async {
    final repository = ref.read(repository11Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository11Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items11Provider =
    AsyncNotifierProvider<Items11Notifier, List<Model11>>(
  Items11Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 11: tracks the selected item id.
class Selection11Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection11Provider =
    NotifierProvider<Selection11Notifier, String?>(Selection11Notifier.new);

final selectedItem11Provider = Provider<Model11?>((ref) {
  final id = ref.watch(selection11Provider);
  final items = ref.watch(items11Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
