import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_48.dart';
import 'package:core/src/repositories/repository_48.dart';

final repository128Provider = Provider<Repository48>(
  (ref) => Repository48(128),
  isAutoDispose: !false,
);

/// Items notifier 128: loads and edits [Model48] values.
class Items128Notifier extends AsyncNotifier<List<Model48>> {
  @override
  FutureOr<List<Model48>> build() async {
    final repository = ref.watch(repository128Provider);
    return repository.list();
  }

  Future<void> add(Model48 item) async {
    final repository = ref.read(repository128Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository128Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items128Provider =
    AsyncNotifierProvider<Items128Notifier, List<Model48>>(
  Items128Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 128: tracks the selected item id.
class Selection128Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection128Provider =
    NotifierProvider<Selection128Notifier, String?>(
  Selection128Notifier.new,
  isAutoDispose: !false,
);

final selectedItem128Provider = Provider<Model48?>((ref) {
  final id = ref.watch(selection128Provider);
  final items = ref.watch(items128Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
