import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_4.dart';
import 'package:core/src/repositories/repository_4.dart';

final repository4Provider = Provider<Repository4>(
  (ref) => Repository4(4),
  isAutoDispose: !false,
);

/// Items notifier 4: loads and edits [Model4] values.
class Items4Notifier extends AsyncNotifier<List<Model4>> {
  @override
  FutureOr<List<Model4>> build() async {
    final repository = ref.watch(repository4Provider);
    return repository.list();
  }

  Future<void> add(Model4 item) async {
    final repository = ref.read(repository4Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository4Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items4Provider =
    AsyncNotifierProvider<Items4Notifier, List<Model4>>(
  Items4Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 4: tracks the selected item id.
class Selection4Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection4Provider =
    NotifierProvider<Selection4Notifier, String?>(Selection4Notifier.new);

final selectedItem4Provider = Provider<Model4?>((ref) {
  final id = ref.watch(selection4Provider);
  final items = ref.watch(items4Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
