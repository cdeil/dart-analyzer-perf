import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_56.dart';
import 'package:core/src/repositories/repository_56.dart';

final repository56Provider = Provider<Repository56>(
  (ref) => Repository56(56),
  isAutoDispose: !false,
);

/// Items notifier 56: loads and edits [Model56] values.
class Items56Notifier extends AsyncNotifier<List<Model56>> {
  @override
  FutureOr<List<Model56>> build() async {
    final repository = ref.watch(repository56Provider);
    return repository.list();
  }

  Future<void> add(Model56 item) async {
    final repository = ref.read(repository56Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository56Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items56Provider =
    AsyncNotifierProvider<Items56Notifier, List<Model56>>(
  Items56Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 56: tracks the selected item id.
class Selection56Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection56Provider =
    NotifierProvider<Selection56Notifier, String?>(Selection56Notifier.new);

final selectedItem56Provider = Provider<Model56?>((ref) {
  final id = ref.watch(selection56Provider);
  final items = ref.watch(items56Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
