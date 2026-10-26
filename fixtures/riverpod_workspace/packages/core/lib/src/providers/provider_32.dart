import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_32.dart';
import 'package:core/src/repositories/repository_32.dart';

final repository32Provider = Provider<Repository32>(
  (ref) => Repository32(32),
  isAutoDispose: !false,
);

/// Items notifier 32: loads and edits [Model32] values.
class Items32Notifier extends AsyncNotifier<List<Model32>> {
  @override
  FutureOr<List<Model32>> build() async {
    final repository = ref.watch(repository32Provider);
    return repository.list();
  }

  Future<void> add(Model32 item) async {
    final repository = ref.read(repository32Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository32Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items32Provider =
    AsyncNotifierProvider<Items32Notifier, List<Model32>>(
  Items32Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 32: tracks the selected item id.
class Selection32Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection32Provider =
    NotifierProvider<Selection32Notifier, String?>(
  Selection32Notifier.new,
  isAutoDispose: !false,
);

final selectedItem32Provider = Provider<Model32?>((ref) {
  final id = ref.watch(selection32Provider);
  final items = ref.watch(items32Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
