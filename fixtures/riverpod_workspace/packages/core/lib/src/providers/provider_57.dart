import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_57.dart';
import 'package:core/src/repositories/repository_57.dart';

final repository57Provider = Provider<Repository57>(
  (ref) => Repository57(57),
  isAutoDispose: !false,
);

/// Items notifier 57: loads and edits [Model57] values.
class Items57Notifier extends AsyncNotifier<List<Model57>> {
  @override
  FutureOr<List<Model57>> build() async {
    final repository = ref.watch(repository57Provider);
    return repository.list();
  }

  Future<void> add(Model57 item) async {
    final repository = ref.read(repository57Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository57Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items57Provider =
    AsyncNotifierProvider<Items57Notifier, List<Model57>>(
  Items57Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 57: tracks the selected item id.
class Selection57Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection57Provider =
    NotifierProvider<Selection57Notifier, String?>(Selection57Notifier.new);

final selectedItem57Provider = Provider<Model57?>((ref) {
  final id = ref.watch(selection57Provider);
  final items = ref.watch(items57Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
