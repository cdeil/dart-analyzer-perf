import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_41.dart';
import 'package:core/src/repositories/repository_41.dart';

final repository41Provider = Provider<Repository41>(
  (ref) => Repository41(41),
  isAutoDispose: !false,
);

/// Items notifier 41: loads and edits [Model41] values.
class Items41Notifier extends AsyncNotifier<List<Model41>> {
  @override
  FutureOr<List<Model41>> build() async {
    final repository = ref.watch(repository41Provider);
    return repository.list();
  }

  Future<void> add(Model41 item) async {
    final repository = ref.read(repository41Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository41Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items41Provider =
    AsyncNotifierProvider<Items41Notifier, List<Model41>>(
  Items41Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 41: tracks the selected item id.
class Selection41Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection41Provider =
    NotifierProvider<Selection41Notifier, String?>(Selection41Notifier.new);

final selectedItem41Provider = Provider<Model41?>((ref) {
  final id = ref.watch(selection41Provider);
  final items = ref.watch(items41Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
