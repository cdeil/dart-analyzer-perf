import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_63.dart';
import 'package:core/src/repositories/repository_63.dart';

final repository143Provider = Provider<Repository63>(
  (ref) => Repository63(143),
  isAutoDispose: !false,
);

/// Items notifier 143: loads and edits [Model63] values.
class Items143Notifier extends AsyncNotifier<List<Model63>> {
  @override
  FutureOr<List<Model63>> build() async {
    final repository = ref.watch(repository143Provider);
    return repository.list();
  }

  Future<void> add(Model63 item) async {
    final repository = ref.read(repository143Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository143Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items143Provider =
    AsyncNotifierProvider<Items143Notifier, List<Model63>>(
  Items143Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 143: tracks the selected item id.
class Selection143Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection143Provider =
    NotifierProvider<Selection143Notifier, String?>(
  Selection143Notifier.new,
  isAutoDispose: !false,
);

final selectedItem143Provider = Provider<Model63?>((ref) {
  final id = ref.watch(selection143Provider);
  final items = ref.watch(items143Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
