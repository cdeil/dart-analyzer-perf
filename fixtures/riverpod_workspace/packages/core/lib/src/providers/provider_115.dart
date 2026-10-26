import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_115.dart';
import 'package:core/src/repositories/repository_35.dart';

final repository115Provider = Provider<Repository35>(
  (ref) => Repository35(115),
  isAutoDispose: !true,
);

/// Items notifier 115: loads and edits [Model115] values.
class Items115Notifier extends AsyncNotifier<List<Model115>> {
  @override
  FutureOr<List<Model115>> build() async {
    final repository = ref.watch(repository115Provider);
    return repository.list();
  }

  Future<void> add(Model115 item) async {
    final repository = ref.read(repository115Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository115Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items115Provider =
    AsyncNotifierProvider<Items115Notifier, List<Model115>>(
  Items115Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 115: tracks the selected item id.
class Selection115Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection115Provider =
    NotifierProvider<Selection115Notifier, String?>(Selection115Notifier.new);

final selectedItem115Provider = Provider<Model115?>((ref) {
  final id = ref.watch(selection115Provider);
  final items = ref.watch(items115Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
