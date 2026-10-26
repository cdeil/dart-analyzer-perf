import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_17.dart';
import 'package:core/src/repositories/repository_17.dart';

final repository17Provider = Provider<Repository17>(
  (ref) => Repository17(17),
  isAutoDispose: !false,
);

/// Items notifier 17: loads and edits [Model17] values.
class Items17Notifier extends AsyncNotifier<List<Model17>> {
  @override
  FutureOr<List<Model17>> build() async {
    final repository = ref.watch(repository17Provider);
    return repository.list();
  }

  Future<void> add(Model17 item) async {
    final repository = ref.read(repository17Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository17Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items17Provider =
    AsyncNotifierProvider<Items17Notifier, List<Model17>>(
  Items17Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 17: tracks the selected item id.
class Selection17Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection17Provider =
    NotifierProvider<Selection17Notifier, String?>(Selection17Notifier.new);

final selectedItem17Provider = Provider<Model17?>((ref) {
  final id = ref.watch(selection17Provider);
  final items = ref.watch(items17Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
