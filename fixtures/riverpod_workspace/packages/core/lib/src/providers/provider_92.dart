import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_12.dart';
import 'package:core/src/repositories/repository_12.dart';

final repository92Provider = Provider<Repository12>(
  (ref) => Repository12(92),
  isAutoDispose: !false,
);

/// Items notifier 92: loads and edits [Model12] values.
class Items92Notifier extends AsyncNotifier<List<Model12>> {
  @override
  FutureOr<List<Model12>> build() async {
    final repository = ref.watch(repository92Provider);
    return repository.list();
  }

  Future<void> add(Model12 item) async {
    final repository = ref.read(repository92Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository92Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items92Provider =
    AsyncNotifierProvider<Items92Notifier, List<Model12>>(
  Items92Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 92: tracks the selected item id.
class Selection92Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection92Provider =
    NotifierProvider<Selection92Notifier, String?>(
  Selection92Notifier.new,
  isAutoDispose: !false,
);

final selectedItem92Provider = Provider<Model12?>((ref) {
  final id = ref.watch(selection92Provider);
  final items = ref.watch(items92Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
