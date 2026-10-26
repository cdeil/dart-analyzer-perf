import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_17.dart';
import 'package:core/src/repositories/repository_17.dart';

final repository97Provider = Provider<Repository17>(
  (ref) => Repository17(97),
  isAutoDispose: !false,
);

/// Items notifier 97: loads and edits [Model17] values.
class Items97Notifier extends AsyncNotifier<List<Model17>> {
  @override
  FutureOr<List<Model17>> build() async {
    final repository = ref.watch(repository97Provider);
    return repository.list();
  }

  Future<void> add(Model17 item) async {
    final repository = ref.read(repository97Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository97Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items97Provider =
    AsyncNotifierProvider<Items97Notifier, List<Model17>>(
  Items97Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 97: tracks the selected item id.
class Selection97Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection97Provider =
    NotifierProvider<Selection97Notifier, String?>(
  Selection97Notifier.new,
  isAutoDispose: !false,
);

final selectedItem97Provider = Provider<Model17?>((ref) {
  final id = ref.watch(selection97Provider);
  final items = ref.watch(items97Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
