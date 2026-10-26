import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_50.dart';
import 'package:core/src/repositories/repository_50.dart';

final repository130Provider = Provider<Repository50>(
  (ref) => Repository50(130),
  isAutoDispose: !true,
);

/// Items notifier 130: loads and edits [Model50] values.
class Items130Notifier extends AsyncNotifier<List<Model50>> {
  @override
  FutureOr<List<Model50>> build() async {
    final repository = ref.watch(repository130Provider);
    return repository.list();
  }

  Future<void> add(Model50 item) async {
    final repository = ref.read(repository130Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository130Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items130Provider =
    AsyncNotifierProvider<Items130Notifier, List<Model50>>(
  Items130Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 130: tracks the selected item id.
class Selection130Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection130Provider =
    NotifierProvider<Selection130Notifier, String?>(
  Selection130Notifier.new,
  isAutoDispose: !true,
);

final selectedItem130Provider = Provider<Model50?>((ref) {
  final id = ref.watch(selection130Provider);
  final items = ref.watch(items130Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
