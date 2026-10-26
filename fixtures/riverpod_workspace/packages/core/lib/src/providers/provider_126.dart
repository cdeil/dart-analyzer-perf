import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_46.dart';
import 'package:core/src/repositories/repository_46.dart';

final repository126Provider = Provider<Repository46>(
  (ref) => Repository46(126),
  isAutoDispose: !false,
);

/// Items notifier 126: loads and edits [Model46] values.
class Items126Notifier extends AsyncNotifier<List<Model46>> {
  @override
  FutureOr<List<Model46>> build() async {
    final repository = ref.watch(repository126Provider);
    return repository.list();
  }

  Future<void> add(Model46 item) async {
    final repository = ref.read(repository126Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository126Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items126Provider =
    AsyncNotifierProvider<Items126Notifier, List<Model46>>(
  Items126Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 126: tracks the selected item id.
class Selection126Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection126Provider =
    NotifierProvider<Selection126Notifier, String?>(
  Selection126Notifier.new,
  isAutoDispose: !false,
);

final selectedItem126Provider = Provider<Model46?>((ref) {
  final id = ref.watch(selection126Provider);
  final items = ref.watch(items126Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
