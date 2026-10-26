import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_15.dart';
import 'package:core/src/repositories/repository_55.dart';

final repository135Provider = Provider<Repository55>(
  (ref) => Repository55(135),
  isAutoDispose: !true,
);

/// Items notifier 135: loads and edits [Model15] values.
class Items135Notifier extends AsyncNotifier<List<Model15>> {
  @override
  FutureOr<List<Model15>> build() async {
    final repository = ref.watch(repository135Provider);
    return repository.list();
  }

  Future<void> add(Model15 item) async {
    final repository = ref.read(repository135Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository135Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items135Provider =
    AsyncNotifierProvider<Items135Notifier, List<Model15>>(
  Items135Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 135: tracks the selected item id.
class Selection135Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection135Provider =
    NotifierProvider<Selection135Notifier, String?>(Selection135Notifier.new);

final selectedItem135Provider = Provider<Model15?>((ref) {
  final id = ref.watch(selection135Provider);
  final items = ref.watch(items135Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
