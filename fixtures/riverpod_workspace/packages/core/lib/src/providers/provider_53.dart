import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_53.dart';
import 'package:core/src/repositories/repository_53.dart';

final repository53Provider = Provider<Repository53>(
  (ref) => Repository53(53),
  isAutoDispose: !false,
);

/// Items notifier 53: loads and edits [Model53] values.
class Items53Notifier extends AsyncNotifier<List<Model53>> {
  @override
  FutureOr<List<Model53>> build() async {
    final repository = ref.watch(repository53Provider);
    return repository.list();
  }

  Future<void> add(Model53 item) async {
    final repository = ref.read(repository53Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository53Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items53Provider =
    AsyncNotifierProvider<Items53Notifier, List<Model53>>(
  Items53Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 53: tracks the selected item id.
class Selection53Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection53Provider =
    NotifierProvider<Selection53Notifier, String?>(Selection53Notifier.new);

final selectedItem53Provider = Provider<Model53?>((ref) {
  final id = ref.watch(selection53Provider);
  final items = ref.watch(items53Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
