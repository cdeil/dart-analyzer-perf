import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_50.dart';
import 'package:core/src/repositories/repository_50.dart';

final repository50Provider = Provider<Repository50>(
  (ref) => Repository50(50),
  isAutoDispose: !true,
);

/// Items notifier 50: loads and edits [Model50] values.
class Items50Notifier extends AsyncNotifier<List<Model50>> {
  @override
  FutureOr<List<Model50>> build() async {
    final repository = ref.watch(repository50Provider);
    return repository.list();
  }

  Future<void> add(Model50 item) async {
    final repository = ref.read(repository50Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository50Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items50Provider =
    AsyncNotifierProvider<Items50Notifier, List<Model50>>(
  Items50Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 50: tracks the selected item id.
class Selection50Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection50Provider =
    NotifierProvider<Selection50Notifier, String?>(
  Selection50Notifier.new,
  isAutoDispose: !true,
);

final selectedItem50Provider = Provider<Model50?>((ref) {
  final id = ref.watch(selection50Provider);
  final items = ref.watch(items50Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
