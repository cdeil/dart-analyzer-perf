import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_19.dart';
import 'package:core/src/repositories/repository_19.dart';

final repository19Provider = Provider<Repository19>(
  (ref) => Repository19(19),
  isAutoDispose: !false,
);

/// Items notifier 19: loads and edits [Model19] values.
class Items19Notifier extends AsyncNotifier<List<Model19>> {
  @override
  FutureOr<List<Model19>> build() async {
    final repository = ref.watch(repository19Provider);
    return repository.list();
  }

  Future<void> add(Model19 item) async {
    final repository = ref.read(repository19Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository19Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items19Provider =
    AsyncNotifierProvider<Items19Notifier, List<Model19>>(
  Items19Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 19: tracks the selected item id.
class Selection19Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection19Provider =
    NotifierProvider<Selection19Notifier, String?>(Selection19Notifier.new);

final selectedItem19Provider = Provider<Model19?>((ref) {
  final id = ref.watch(selection19Provider);
  final items = ref.watch(items19Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
