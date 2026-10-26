import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_7.dart';
import 'package:core/src/repositories/repository_7.dart';

final repository7Provider = Provider<Repository7>(
  (ref) => Repository7(7),
  isAutoDispose: !false,
);

/// Items notifier 7: loads and edits [Model7] values.
class Items7Notifier extends AsyncNotifier<List<Model7>> {
  @override
  FutureOr<List<Model7>> build() async {
    final repository = ref.watch(repository7Provider);
    return repository.list();
  }

  Future<void> add(Model7 item) async {
    final repository = ref.read(repository7Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository7Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items7Provider =
    AsyncNotifierProvider<Items7Notifier, List<Model7>>(
  Items7Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 7: tracks the selected item id.
class Selection7Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection7Provider =
    NotifierProvider<Selection7Notifier, String?>(
  Selection7Notifier.new,
  isAutoDispose: !false,
);

final selectedItem7Provider = Provider<Model7?>((ref) {
  final id = ref.watch(selection7Provider);
  final items = ref.watch(items7Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
