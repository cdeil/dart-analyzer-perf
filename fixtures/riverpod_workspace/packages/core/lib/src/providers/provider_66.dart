import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_66.dart';
import 'package:core/src/repositories/repository_66.dart';

final repository66Provider = Provider<Repository66>(
  (ref) => Repository66(66),
  isAutoDispose: !false,
);

/// Items notifier 66: loads and edits [Model66] values.
class Items66Notifier extends AsyncNotifier<List<Model66>> {
  @override
  FutureOr<List<Model66>> build() async {
    final repository = ref.watch(repository66Provider);
    return repository.list();
  }

  Future<void> add(Model66 item) async {
    final repository = ref.read(repository66Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository66Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items66Provider =
    AsyncNotifierProvider<Items66Notifier, List<Model66>>(
  Items66Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 66: tracks the selected item id.
class Selection66Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection66Provider =
    NotifierProvider<Selection66Notifier, String?>(Selection66Notifier.new);

final selectedItem66Provider = Provider<Model66?>((ref) {
  final id = ref.watch(selection66Provider);
  final items = ref.watch(items66Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
