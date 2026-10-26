import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_77.dart';
import 'package:core/src/repositories/repository_77.dart';

final repository77Provider = Provider<Repository77>(
  (ref) => Repository77(77),
  isAutoDispose: !false,
);

/// Items notifier 77: loads and edits [Model77] values.
class Items77Notifier extends AsyncNotifier<List<Model77>> {
  @override
  FutureOr<List<Model77>> build() async {
    final repository = ref.watch(repository77Provider);
    return repository.list();
  }

  Future<void> add(Model77 item) async {
    final repository = ref.read(repository77Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository77Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items77Provider =
    AsyncNotifierProvider<Items77Notifier, List<Model77>>(
  Items77Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 77: tracks the selected item id.
class Selection77Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection77Provider =
    NotifierProvider<Selection77Notifier, String?>(
  Selection77Notifier.new,
  isAutoDispose: !false,
);

final selectedItem77Provider = Provider<Model77?>((ref) {
  final id = ref.watch(selection77Provider);
  final items = ref.watch(items77Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
