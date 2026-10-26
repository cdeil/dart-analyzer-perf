import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_5.dart';
import 'package:core/src/repositories/repository_5.dart';

final repository85Provider = Provider<Repository5>(
  (ref) => Repository5(85),
  isAutoDispose: !true,
);

/// Items notifier 85: loads and edits [Model5] values.
class Items85Notifier extends AsyncNotifier<List<Model5>> {
  @override
  FutureOr<List<Model5>> build() async {
    final repository = ref.watch(repository85Provider);
    return repository.list();
  }

  Future<void> add(Model5 item) async {
    final repository = ref.read(repository85Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository85Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items85Provider =
    AsyncNotifierProvider<Items85Notifier, List<Model5>>(
  Items85Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 85: tracks the selected item id.
class Selection85Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection85Provider =
    NotifierProvider<Selection85Notifier, String?>(
  Selection85Notifier.new,
  isAutoDispose: !true,
);

final selectedItem85Provider = Provider<Model5?>((ref) {
  final id = ref.watch(selection85Provider);
  final items = ref.watch(items85Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
