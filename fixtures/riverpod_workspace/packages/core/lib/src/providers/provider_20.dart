import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_20.dart';
import 'package:core/src/repositories/repository_20.dart';

final repository20Provider = Provider<Repository20>(
  (ref) => Repository20(20),
  isAutoDispose: !true,
);

/// Items notifier 20: loads and edits [Model20] values.
class Items20Notifier extends AsyncNotifier<List<Model20>> {
  @override
  FutureOr<List<Model20>> build() async {
    final repository = ref.watch(repository20Provider);
    return repository.list();
  }

  Future<void> add(Model20 item) async {
    final repository = ref.read(repository20Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository20Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items20Provider =
    AsyncNotifierProvider<Items20Notifier, List<Model20>>(
  Items20Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 20: tracks the selected item id.
class Selection20Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection20Provider =
    NotifierProvider<Selection20Notifier, String?>(
  Selection20Notifier.new,
  isAutoDispose: !true,
);

final selectedItem20Provider = Provider<Model20?>((ref) {
  final id = ref.watch(selection20Provider);
  final items = ref.watch(items20Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
