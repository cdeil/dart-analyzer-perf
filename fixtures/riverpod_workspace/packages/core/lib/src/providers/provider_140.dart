import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_60.dart';
import 'package:core/src/repositories/repository_60.dart';

final repository140Provider = Provider<Repository60>(
  (ref) => Repository60(140),
  isAutoDispose: !true,
);

/// Items notifier 140: loads and edits [Model60] values.
class Items140Notifier extends AsyncNotifier<List<Model60>> {
  @override
  FutureOr<List<Model60>> build() async {
    final repository = ref.watch(repository140Provider);
    return repository.list();
  }

  Future<void> add(Model60 item) async {
    final repository = ref.read(repository140Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository140Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items140Provider =
    AsyncNotifierProvider<Items140Notifier, List<Model60>>(
  Items140Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 140: tracks the selected item id.
class Selection140Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection140Provider =
    NotifierProvider<Selection140Notifier, String?>(
  Selection140Notifier.new,
  isAutoDispose: !true,
);

final selectedItem140Provider = Provider<Model60?>((ref) {
  final id = ref.watch(selection140Provider);
  final items = ref.watch(items140Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
