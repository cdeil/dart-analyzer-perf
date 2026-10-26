import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_31.dart';
import 'package:core/src/repositories/repository_31.dart';

final repository31Provider = Provider<Repository31>(
  (ref) => Repository31(31),
  isAutoDispose: !false,
);

/// Items notifier 31: loads and edits [Model31] values.
class Items31Notifier extends AsyncNotifier<List<Model31>> {
  @override
  FutureOr<List<Model31>> build() async {
    final repository = ref.watch(repository31Provider);
    return repository.list();
  }

  Future<void> add(Model31 item) async {
    final repository = ref.read(repository31Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository31Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items31Provider =
    AsyncNotifierProvider<Items31Notifier, List<Model31>>(
  Items31Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 31: tracks the selected item id.
class Selection31Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection31Provider =
    NotifierProvider<Selection31Notifier, String?>(
  Selection31Notifier.new,
  isAutoDispose: !false,
);

final selectedItem31Provider = Provider<Model31?>((ref) {
  final id = ref.watch(selection31Provider);
  final items = ref.watch(items31Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
