import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_53.dart';
import 'package:core/src/repositories/repository_53.dart';

final repository133Provider = Provider<Repository53>(
  (ref) => Repository53(133),
  isAutoDispose: !false,
);

/// Items notifier 133: loads and edits [Model53] values.
class Items133Notifier extends AsyncNotifier<List<Model53>> {
  @override
  FutureOr<List<Model53>> build() async {
    final repository = ref.watch(repository133Provider);
    return repository.list();
  }

  Future<void> add(Model53 item) async {
    final repository = ref.read(repository133Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository133Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items133Provider =
    AsyncNotifierProvider<Items133Notifier, List<Model53>>(
  Items133Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 133: tracks the selected item id.
class Selection133Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection133Provider =
    NotifierProvider<Selection133Notifier, String?>(
  Selection133Notifier.new,
  isAutoDispose: !false,
);

final selectedItem133Provider = Provider<Model53?>((ref) {
  final id = ref.watch(selection133Provider);
  final items = ref.watch(items133Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
