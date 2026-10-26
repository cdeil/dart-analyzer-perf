import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_60.dart';
import 'package:core/src/repositories/repository_60.dart';

final repository60Provider = Provider<Repository60>(
  (ref) => Repository60(60),
  isAutoDispose: !true,
);

/// Items notifier 60: loads and edits [Model60] values.
class Items60Notifier extends AsyncNotifier<List<Model60>> {
  @override
  FutureOr<List<Model60>> build() async {
    final repository = ref.watch(repository60Provider);
    return repository.list();
  }

  Future<void> add(Model60 item) async {
    final repository = ref.read(repository60Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository60Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items60Provider =
    AsyncNotifierProvider<Items60Notifier, List<Model60>>(
  Items60Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 60: tracks the selected item id.
class Selection60Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection60Provider =
    NotifierProvider<Selection60Notifier, String?>(Selection60Notifier.new);

final selectedItem60Provider = Provider<Model60?>((ref) {
  final id = ref.watch(selection60Provider);
  final items = ref.watch(items60Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
