import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_119.dart';
import 'package:core/src/repositories/repository_39.dart';

final repository119Provider = Provider<Repository39>(
  (ref) => Repository39(119),
  isAutoDispose: !false,
);

/// Items notifier 119: loads and edits [Model119] values.
class Items119Notifier extends AsyncNotifier<List<Model119>> {
  @override
  FutureOr<List<Model119>> build() async {
    final repository = ref.watch(repository119Provider);
    return repository.list();
  }

  Future<void> add(Model119 item) async {
    final repository = ref.read(repository119Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository119Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items119Provider =
    AsyncNotifierProvider<Items119Notifier, List<Model119>>(
  Items119Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 119: tracks the selected item id.
class Selection119Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection119Provider =
    NotifierProvider<Selection119Notifier, String?>(Selection119Notifier.new);

final selectedItem119Provider = Provider<Model119?>((ref) {
  final id = ref.watch(selection119Provider);
  final items = ref.watch(items119Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
