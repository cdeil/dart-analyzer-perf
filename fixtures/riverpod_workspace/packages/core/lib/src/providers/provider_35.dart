import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_35.dart';
import 'package:core/src/repositories/repository_35.dart';

final repository35Provider = Provider<Repository35>(
  (ref) => Repository35(35),
  isAutoDispose: !true,
);

/// Items notifier 35: loads and edits [Model35] values.
class Items35Notifier extends AsyncNotifier<List<Model35>> {
  @override
  FutureOr<List<Model35>> build() async {
    final repository = ref.watch(repository35Provider);
    return repository.list();
  }

  Future<void> add(Model35 item) async {
    final repository = ref.read(repository35Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository35Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items35Provider =
    AsyncNotifierProvider<Items35Notifier, List<Model35>>(
  Items35Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 35: tracks the selected item id.
class Selection35Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection35Provider =
    NotifierProvider<Selection35Notifier, String?>(
  Selection35Notifier.new,
  isAutoDispose: !true,
);

final selectedItem35Provider = Provider<Model35?>((ref) {
  final id = ref.watch(selection35Provider);
  final items = ref.watch(items35Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
