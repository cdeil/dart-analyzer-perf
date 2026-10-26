import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_51.dart';
import 'package:core/src/repositories/repository_51.dart';

final repository51Provider = Provider<Repository51>(
  (ref) => Repository51(51),
  isAutoDispose: !false,
);

/// Items notifier 51: loads and edits [Model51] values.
class Items51Notifier extends AsyncNotifier<List<Model51>> {
  @override
  FutureOr<List<Model51>> build() async {
    final repository = ref.watch(repository51Provider);
    return repository.list();
  }

  Future<void> add(Model51 item) async {
    final repository = ref.read(repository51Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository51Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items51Provider =
    AsyncNotifierProvider<Items51Notifier, List<Model51>>(
  Items51Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 51: tracks the selected item id.
class Selection51Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection51Provider =
    NotifierProvider<Selection51Notifier, String?>(
  Selection51Notifier.new,
  isAutoDispose: !false,
);

final selectedItem51Provider = Provider<Model51?>((ref) {
  final id = ref.watch(selection51Provider);
  final items = ref.watch(items51Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
