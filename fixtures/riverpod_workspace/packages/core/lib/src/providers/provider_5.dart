import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_5.dart';
import 'package:core/src/repositories/repository_5.dart';

final repository5Provider = Provider<Repository5>(
  (ref) => Repository5(5),
  isAutoDispose: !true,
);

/// Items notifier 5: loads and edits [Model5] values.
class Items5Notifier extends AsyncNotifier<List<Model5>> {
  @override
  FutureOr<List<Model5>> build() async {
    final repository = ref.watch(repository5Provider);
    return repository.list();
  }

  Future<void> add(Model5 item) async {
    final repository = ref.read(repository5Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository5Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items5Provider =
    AsyncNotifierProvider<Items5Notifier, List<Model5>>(
  Items5Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 5: tracks the selected item id.
class Selection5Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection5Provider =
    NotifierProvider<Selection5Notifier, String?>(
  Selection5Notifier.new,
  isAutoDispose: !true,
);

final selectedItem5Provider = Provider<Model5?>((ref) {
  final id = ref.watch(selection5Provider);
  final items = ref.watch(items5Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
