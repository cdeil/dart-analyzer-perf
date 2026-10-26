import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_2.dart';
import 'package:core/src/repositories/repository_2.dart';

final repository2Provider = Provider<Repository2>(
  (ref) => Repository2(2),
  isAutoDispose: !false,
);

/// Items notifier 2: loads and edits [Model2] values.
class Items2Notifier extends AsyncNotifier<List<Model2>> {
  @override
  FutureOr<List<Model2>> build() async {
    final repository = ref.watch(repository2Provider);
    return repository.list();
  }

  Future<void> add(Model2 item) async {
    final repository = ref.read(repository2Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository2Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items2Provider =
    AsyncNotifierProvider<Items2Notifier, List<Model2>>(
  Items2Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 2: tracks the selected item id.
class Selection2Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection2Provider =
    NotifierProvider<Selection2Notifier, String?>(
  Selection2Notifier.new,
  isAutoDispose: !false,
);

final selectedItem2Provider = Provider<Model2?>((ref) {
  final id = ref.watch(selection2Provider);
  final items = ref.watch(items2Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
