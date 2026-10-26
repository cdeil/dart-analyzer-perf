import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_10.dart';
import 'package:core/src/repositories/repository_10.dart';

final repository10Provider = Provider<Repository10>(
  (ref) => Repository10(10),
  isAutoDispose: !true,
);

/// Items notifier 10: loads and edits [Model10] values.
class Items10Notifier extends AsyncNotifier<List<Model10>> {
  @override
  FutureOr<List<Model10>> build() async {
    final repository = ref.watch(repository10Provider);
    return repository.list();
  }

  Future<void> add(Model10 item) async {
    final repository = ref.read(repository10Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository10Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items10Provider =
    AsyncNotifierProvider<Items10Notifier, List<Model10>>(
  Items10Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 10: tracks the selected item id.
class Selection10Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection10Provider =
    NotifierProvider<Selection10Notifier, String?>(
  Selection10Notifier.new,
  isAutoDispose: !true,
);

final selectedItem10Provider = Provider<Model10?>((ref) {
  final id = ref.watch(selection10Provider);
  final items = ref.watch(items10Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
