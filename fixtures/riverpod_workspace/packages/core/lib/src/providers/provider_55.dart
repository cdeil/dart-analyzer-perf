import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_55.dart';
import 'package:core/src/repositories/repository_55.dart';

final repository55Provider = Provider<Repository55>(
  (ref) => Repository55(55),
  isAutoDispose: !true,
);

/// Items notifier 55: loads and edits [Model55] values.
class Items55Notifier extends AsyncNotifier<List<Model55>> {
  @override
  FutureOr<List<Model55>> build() async {
    final repository = ref.watch(repository55Provider);
    return repository.list();
  }

  Future<void> add(Model55 item) async {
    final repository = ref.read(repository55Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository55Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items55Provider =
    AsyncNotifierProvider<Items55Notifier, List<Model55>>(
  Items55Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 55: tracks the selected item id.
class Selection55Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection55Provider =
    NotifierProvider<Selection55Notifier, String?>(
  Selection55Notifier.new,
  isAutoDispose: !true,
);

final selectedItem55Provider = Provider<Model55?>((ref) {
  final id = ref.watch(selection55Provider);
  final items = ref.watch(items55Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
