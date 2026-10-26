import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_58.dart';
import 'package:core/src/repositories/repository_58.dart';

final repository58Provider = Provider<Repository58>(
  (ref) => Repository58(58),
  isAutoDispose: !false,
);

/// Items notifier 58: loads and edits [Model58] values.
class Items58Notifier extends AsyncNotifier<List<Model58>> {
  @override
  FutureOr<List<Model58>> build() async {
    final repository = ref.watch(repository58Provider);
    return repository.list();
  }

  Future<void> add(Model58 item) async {
    final repository = ref.read(repository58Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository58Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items58Provider =
    AsyncNotifierProvider<Items58Notifier, List<Model58>>(
  Items58Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 58: tracks the selected item id.
class Selection58Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection58Provider =
    NotifierProvider<Selection58Notifier, String?>(
  Selection58Notifier.new,
  isAutoDispose: !false,
);

final selectedItem58Provider = Provider<Model58?>((ref) {
  final id = ref.watch(selection58Provider);
  final items = ref.watch(items58Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
