import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_75.dart';
import 'package:core/src/repositories/repository_75.dart';

final repository75Provider = Provider<Repository75>(
  (ref) => Repository75(75),
  isAutoDispose: !true,
);

/// Items notifier 75: loads and edits [Model75] values.
class Items75Notifier extends AsyncNotifier<List<Model75>> {
  @override
  FutureOr<List<Model75>> build() async {
    final repository = ref.watch(repository75Provider);
    return repository.list();
  }

  Future<void> add(Model75 item) async {
    final repository = ref.read(repository75Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository75Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items75Provider =
    AsyncNotifierProvider<Items75Notifier, List<Model75>>(
  Items75Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 75: tracks the selected item id.
class Selection75Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection75Provider =
    NotifierProvider<Selection75Notifier, String?>(Selection75Notifier.new);

final selectedItem75Provider = Provider<Model75?>((ref) {
  final id = ref.watch(selection75Provider);
  final items = ref.watch(items75Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
