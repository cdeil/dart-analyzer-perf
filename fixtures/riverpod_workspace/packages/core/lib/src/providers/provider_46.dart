import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_46.dart';
import 'package:core/src/repositories/repository_46.dart';

final repository46Provider = Provider<Repository46>(
  (ref) => Repository46(46),
  isAutoDispose: !false,
);

/// Items notifier 46: loads and edits [Model46] values.
class Items46Notifier extends AsyncNotifier<List<Model46>> {
  @override
  FutureOr<List<Model46>> build() async {
    final repository = ref.watch(repository46Provider);
    return repository.list();
  }

  Future<void> add(Model46 item) async {
    final repository = ref.read(repository46Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository46Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items46Provider =
    AsyncNotifierProvider<Items46Notifier, List<Model46>>(
  Items46Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 46: tracks the selected item id.
class Selection46Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection46Provider =
    NotifierProvider<Selection46Notifier, String?>(Selection46Notifier.new);

final selectedItem46Provider = Provider<Model46?>((ref) {
  final id = ref.watch(selection46Provider);
  final items = ref.watch(items46Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
