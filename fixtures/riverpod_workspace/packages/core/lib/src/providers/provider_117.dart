import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_117.dart';
import 'package:core/src/repositories/repository_37.dart';

final repository117Provider = Provider<Repository37>(
  (ref) => Repository37(117),
  isAutoDispose: !false,
);

/// Items notifier 117: loads and edits [Model117] values.
class Items117Notifier extends AsyncNotifier<List<Model117>> {
  @override
  FutureOr<List<Model117>> build() async {
    final repository = ref.watch(repository117Provider);
    return repository.list();
  }

  Future<void> add(Model117 item) async {
    final repository = ref.read(repository117Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository117Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items117Provider =
    AsyncNotifierProvider<Items117Notifier, List<Model117>>(
  Items117Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 117: tracks the selected item id.
class Selection117Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection117Provider =
    NotifierProvider<Selection117Notifier, String?>(Selection117Notifier.new);

final selectedItem117Provider = Provider<Model117?>((ref) {
  final id = ref.watch(selection117Provider);
  final items = ref.watch(items117Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
