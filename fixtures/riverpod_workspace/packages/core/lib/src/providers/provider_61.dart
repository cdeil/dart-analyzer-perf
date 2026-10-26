import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_61.dart';
import 'package:core/src/repositories/repository_61.dart';

final repository61Provider = Provider<Repository61>(
  (ref) => Repository61(61),
  isAutoDispose: !false,
);

/// Items notifier 61: loads and edits [Model61] values.
class Items61Notifier extends AsyncNotifier<List<Model61>> {
  @override
  FutureOr<List<Model61>> build() async {
    final repository = ref.watch(repository61Provider);
    return repository.list();
  }

  Future<void> add(Model61 item) async {
    final repository = ref.read(repository61Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository61Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items61Provider =
    AsyncNotifierProvider<Items61Notifier, List<Model61>>(
  Items61Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 61: tracks the selected item id.
class Selection61Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection61Provider =
    NotifierProvider<Selection61Notifier, String?>(Selection61Notifier.new);

final selectedItem61Provider = Provider<Model61?>((ref) {
  final id = ref.watch(selection61Provider);
  final items = ref.watch(items61Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
