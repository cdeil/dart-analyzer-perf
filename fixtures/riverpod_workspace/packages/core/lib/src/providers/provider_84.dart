import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_4.dart';
import 'package:core/src/repositories/repository_4.dart';

final repository84Provider = Provider<Repository4>(
  (ref) => Repository4(84),
  isAutoDispose: !false,
);

/// Items notifier 84: loads and edits [Model4] values.
class Items84Notifier extends AsyncNotifier<List<Model4>> {
  @override
  FutureOr<List<Model4>> build() async {
    final repository = ref.watch(repository84Provider);
    return repository.list();
  }

  Future<void> add(Model4 item) async {
    final repository = ref.read(repository84Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository84Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items84Provider =
    AsyncNotifierProvider<Items84Notifier, List<Model4>>(
  Items84Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 84: tracks the selected item id.
class Selection84Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection84Provider =
    NotifierProvider<Selection84Notifier, String?>(
  Selection84Notifier.new,
  isAutoDispose: !false,
);

final selectedItem84Provider = Provider<Model4?>((ref) {
  final id = ref.watch(selection84Provider);
  final items = ref.watch(items84Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
