import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_24.dart';
import 'package:core/src/repositories/repository_24.dart';

final repository24Provider = Provider<Repository24>(
  (ref) => Repository24(24),
  isAutoDispose: !false,
);

/// Items notifier 24: loads and edits [Model24] values.
class Items24Notifier extends AsyncNotifier<List<Model24>> {
  @override
  FutureOr<List<Model24>> build() async {
    final repository = ref.watch(repository24Provider);
    return repository.list();
  }

  Future<void> add(Model24 item) async {
    final repository = ref.read(repository24Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository24Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items24Provider =
    AsyncNotifierProvider<Items24Notifier, List<Model24>>(
  Items24Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 24: tracks the selected item id.
class Selection24Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection24Provider =
    NotifierProvider<Selection24Notifier, String?>(
  Selection24Notifier.new,
  isAutoDispose: !false,
);

final selectedItem24Provider = Provider<Model24?>((ref) {
  final id = ref.watch(selection24Provider);
  final items = ref.watch(items24Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
