import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_44.dart';
import 'package:core/src/repositories/repository_44.dart';

final repository44Provider = Provider<Repository44>(
  (ref) => Repository44(44),
  isAutoDispose: !false,
);

/// Items notifier 44: loads and edits [Model44] values.
class Items44Notifier extends AsyncNotifier<List<Model44>> {
  @override
  FutureOr<List<Model44>> build() async {
    final repository = ref.watch(repository44Provider);
    return repository.list();
  }

  Future<void> add(Model44 item) async {
    final repository = ref.read(repository44Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository44Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items44Provider =
    AsyncNotifierProvider<Items44Notifier, List<Model44>>(
  Items44Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 44: tracks the selected item id.
class Selection44Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection44Provider =
    NotifierProvider<Selection44Notifier, String?>(
  Selection44Notifier.new,
  isAutoDispose: !false,
);

final selectedItem44Provider = Provider<Model44?>((ref) {
  final id = ref.watch(selection44Provider);
  final items = ref.watch(items44Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
