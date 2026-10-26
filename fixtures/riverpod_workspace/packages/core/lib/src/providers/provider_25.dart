import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_25.dart';
import 'package:core/src/repositories/repository_25.dart';

final repository25Provider = Provider<Repository25>(
  (ref) => Repository25(25),
  isAutoDispose: !true,
);

/// Items notifier 25: loads and edits [Model25] values.
class Items25Notifier extends AsyncNotifier<List<Model25>> {
  @override
  FutureOr<List<Model25>> build() async {
    final repository = ref.watch(repository25Provider);
    return repository.list();
  }

  Future<void> add(Model25 item) async {
    final repository = ref.read(repository25Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository25Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items25Provider =
    AsyncNotifierProvider<Items25Notifier, List<Model25>>(
  Items25Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 25: tracks the selected item id.
class Selection25Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection25Provider =
    NotifierProvider<Selection25Notifier, String?>(
  Selection25Notifier.new,
  isAutoDispose: !true,
);

final selectedItem25Provider = Provider<Model25?>((ref) {
  final id = ref.watch(selection25Provider);
  final items = ref.watch(items25Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
