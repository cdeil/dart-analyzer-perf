import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_27.dart';
import 'package:core/src/repositories/repository_27.dart';

final repository27Provider = Provider<Repository27>(
  (ref) => Repository27(27),
  isAutoDispose: !false,
);

/// Items notifier 27: loads and edits [Model27] values.
class Items27Notifier extends AsyncNotifier<List<Model27>> {
  @override
  FutureOr<List<Model27>> build() async {
    final repository = ref.watch(repository27Provider);
    return repository.list();
  }

  Future<void> add(Model27 item) async {
    final repository = ref.read(repository27Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository27Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items27Provider =
    AsyncNotifierProvider<Items27Notifier, List<Model27>>(
  Items27Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 27: tracks the selected item id.
class Selection27Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection27Provider =
    NotifierProvider<Selection27Notifier, String?>(Selection27Notifier.new);

final selectedItem27Provider = Provider<Model27?>((ref) {
  final id = ref.watch(selection27Provider);
  final items = ref.watch(items27Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
