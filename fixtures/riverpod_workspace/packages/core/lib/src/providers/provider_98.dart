import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_98.dart';
import 'package:core/src/repositories/repository_18.dart';

final repository98Provider = Provider<Repository18>(
  (ref) => Repository18(98),
  isAutoDispose: !false,
);

/// Items notifier 98: loads and edits [Model98] values.
class Items98Notifier extends AsyncNotifier<List<Model98>> {
  @override
  FutureOr<List<Model98>> build() async {
    final repository = ref.watch(repository98Provider);
    return repository.list();
  }

  Future<void> add(Model98 item) async {
    final repository = ref.read(repository98Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository98Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items98Provider =
    AsyncNotifierProvider<Items98Notifier, List<Model98>>(
  Items98Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 98: tracks the selected item id.
class Selection98Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection98Provider =
    NotifierProvider<Selection98Notifier, String?>(Selection98Notifier.new);

final selectedItem98Provider = Provider<Model98?>((ref) {
  final id = ref.watch(selection98Provider);
  final items = ref.watch(items98Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
