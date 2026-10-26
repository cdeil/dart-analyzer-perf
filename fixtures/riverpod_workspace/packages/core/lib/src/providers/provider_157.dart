import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_37.dart';
import 'package:core/src/repositories/repository_77.dart';

final repository157Provider = Provider<Repository77>(
  (ref) => Repository77(157),
  isAutoDispose: !false,
);

/// Items notifier 157: loads and edits [Model37] values.
class Items157Notifier extends AsyncNotifier<List<Model37>> {
  @override
  FutureOr<List<Model37>> build() async {
    final repository = ref.watch(repository157Provider);
    return repository.list();
  }

  Future<void> add(Model37 item) async {
    final repository = ref.read(repository157Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository157Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items157Provider =
    AsyncNotifierProvider<Items157Notifier, List<Model37>>(
  Items157Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 157: tracks the selected item id.
class Selection157Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection157Provider =
    NotifierProvider<Selection157Notifier, String?>(Selection157Notifier.new);

final selectedItem157Provider = Provider<Model37?>((ref) {
  final id = ref.watch(selection157Provider);
  final items = ref.watch(items157Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
