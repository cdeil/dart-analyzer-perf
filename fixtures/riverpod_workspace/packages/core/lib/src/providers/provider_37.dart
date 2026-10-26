import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_37.dart';
import 'package:core/src/repositories/repository_37.dart';

final repository37Provider = Provider<Repository37>(
  (ref) => Repository37(37),
  isAutoDispose: !false,
);

/// Items notifier 37: loads and edits [Model37] values.
class Items37Notifier extends AsyncNotifier<List<Model37>> {
  @override
  FutureOr<List<Model37>> build() async {
    final repository = ref.watch(repository37Provider);
    return repository.list();
  }

  Future<void> add(Model37 item) async {
    final repository = ref.read(repository37Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository37Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items37Provider =
    AsyncNotifierProvider<Items37Notifier, List<Model37>>(
  Items37Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 37: tracks the selected item id.
class Selection37Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection37Provider =
    NotifierProvider<Selection37Notifier, String?>(
  Selection37Notifier.new,
  isAutoDispose: !false,
);

final selectedItem37Provider = Provider<Model37?>((ref) {
  final id = ref.watch(selection37Provider);
  final items = ref.watch(items37Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
