import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_48.dart';
import 'package:core/src/repositories/repository_48.dart';

final repository48Provider = Provider<Repository48>(
  (ref) => Repository48(48),
  isAutoDispose: !false,
);

/// Items notifier 48: loads and edits [Model48] values.
class Items48Notifier extends AsyncNotifier<List<Model48>> {
  @override
  FutureOr<List<Model48>> build() async {
    final repository = ref.watch(repository48Provider);
    return repository.list();
  }

  Future<void> add(Model48 item) async {
    final repository = ref.read(repository48Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository48Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items48Provider =
    AsyncNotifierProvider<Items48Notifier, List<Model48>>(
  Items48Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 48: tracks the selected item id.
class Selection48Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection48Provider =
    NotifierProvider<Selection48Notifier, String?>(
  Selection48Notifier.new,
  isAutoDispose: !false,
);

final selectedItem48Provider = Provider<Model48?>((ref) {
  final id = ref.watch(selection48Provider);
  final items = ref.watch(items48Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
