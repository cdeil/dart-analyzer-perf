import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_3.dart';
import 'package:core/src/repositories/repository_3.dart';

final repository3Provider = Provider<Repository3>(
  (ref) => Repository3(3),
  isAutoDispose: !false,
);

/// Items notifier 3: loads and edits [Model3] values.
class Items3Notifier extends AsyncNotifier<List<Model3>> {
  @override
  FutureOr<List<Model3>> build() async {
    final repository = ref.watch(repository3Provider);
    return repository.list();
  }

  Future<void> add(Model3 item) async {
    final repository = ref.read(repository3Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository3Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items3Provider =
    AsyncNotifierProvider<Items3Notifier, List<Model3>>(
  Items3Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 3: tracks the selected item id.
class Selection3Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection3Provider =
    NotifierProvider<Selection3Notifier, String?>(
  Selection3Notifier.new,
  isAutoDispose: !false,
);

final selectedItem3Provider = Provider<Model3?>((ref) {
  final id = ref.watch(selection3Provider);
  final items = ref.watch(items3Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
