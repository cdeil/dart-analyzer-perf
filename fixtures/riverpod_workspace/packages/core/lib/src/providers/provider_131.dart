import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_51.dart';
import 'package:core/src/repositories/repository_51.dart';

final repository131Provider = Provider<Repository51>(
  (ref) => Repository51(131),
  isAutoDispose: !false,
);

/// Items notifier 131: loads and edits [Model51] values.
class Items131Notifier extends AsyncNotifier<List<Model51>> {
  @override
  FutureOr<List<Model51>> build() async {
    final repository = ref.watch(repository131Provider);
    return repository.list();
  }

  Future<void> add(Model51 item) async {
    final repository = ref.read(repository131Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository131Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items131Provider =
    AsyncNotifierProvider<Items131Notifier, List<Model51>>(
  Items131Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 131: tracks the selected item id.
class Selection131Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection131Provider =
    NotifierProvider<Selection131Notifier, String?>(
  Selection131Notifier.new,
  isAutoDispose: !false,
);

final selectedItem131Provider = Provider<Model51?>((ref) {
  final id = ref.watch(selection131Provider);
  final items = ref.watch(items131Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
