import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_14.dart';
import 'package:core/src/repositories/repository_14.dart';

final repository94Provider = Provider<Repository14>(
  (ref) => Repository14(94),
  isAutoDispose: !false,
);

/// Items notifier 94: loads and edits [Model14] values.
class Items94Notifier extends AsyncNotifier<List<Model14>> {
  @override
  FutureOr<List<Model14>> build() async {
    final repository = ref.watch(repository94Provider);
    return repository.list();
  }

  Future<void> add(Model14 item) async {
    final repository = ref.read(repository94Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository94Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items94Provider =
    AsyncNotifierProvider<Items94Notifier, List<Model14>>(
  Items94Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 94: tracks the selected item id.
class Selection94Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection94Provider =
    NotifierProvider<Selection94Notifier, String?>(
  Selection94Notifier.new,
  isAutoDispose: !false,
);

final selectedItem94Provider = Provider<Model14?>((ref) {
  final id = ref.watch(selection94Provider);
  final items = ref.watch(items94Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
