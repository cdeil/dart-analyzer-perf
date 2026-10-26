import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_14.dart';
import 'package:core/src/repositories/repository_54.dart';

final repository134Provider = Provider<Repository54>(
  (ref) => Repository54(134),
  isAutoDispose: !false,
);

/// Items notifier 134: loads and edits [Model14] values.
class Items134Notifier extends AsyncNotifier<List<Model14>> {
  @override
  FutureOr<List<Model14>> build() async {
    final repository = ref.watch(repository134Provider);
    return repository.list();
  }

  Future<void> add(Model14 item) async {
    final repository = ref.read(repository134Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository134Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items134Provider =
    AsyncNotifierProvider<Items134Notifier, List<Model14>>(
  Items134Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 134: tracks the selected item id.
class Selection134Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection134Provider =
    NotifierProvider<Selection134Notifier, String?>(Selection134Notifier.new);

final selectedItem134Provider = Provider<Model14?>((ref) {
  final id = ref.watch(selection134Provider);
  final items = ref.watch(items134Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
