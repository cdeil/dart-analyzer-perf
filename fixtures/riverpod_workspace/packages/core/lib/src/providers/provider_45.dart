import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_45.dart';
import 'package:core/src/repositories/repository_45.dart';

final repository45Provider = Provider<Repository45>(
  (ref) => Repository45(45),
  isAutoDispose: !true,
);

/// Items notifier 45: loads and edits [Model45] values.
class Items45Notifier extends AsyncNotifier<List<Model45>> {
  @override
  FutureOr<List<Model45>> build() async {
    final repository = ref.watch(repository45Provider);
    return repository.list();
  }

  Future<void> add(Model45 item) async {
    final repository = ref.read(repository45Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository45Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items45Provider =
    AsyncNotifierProvider<Items45Notifier, List<Model45>>(
  Items45Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 45: tracks the selected item id.
class Selection45Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection45Provider =
    NotifierProvider<Selection45Notifier, String?>(
  Selection45Notifier.new,
  isAutoDispose: !true,
);

final selectedItem45Provider = Provider<Model45?>((ref) {
  final id = ref.watch(selection45Provider);
  final items = ref.watch(items45Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
