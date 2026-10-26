import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_75.dart';
import 'package:core/src/repositories/repository_75.dart';

final repository155Provider = Provider<Repository75>(
  (ref) => Repository75(155),
  isAutoDispose: !true,
);

/// Items notifier 155: loads and edits [Model75] values.
class Items155Notifier extends AsyncNotifier<List<Model75>> {
  @override
  FutureOr<List<Model75>> build() async {
    final repository = ref.watch(repository155Provider);
    return repository.list();
  }

  Future<void> add(Model75 item) async {
    final repository = ref.read(repository155Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository155Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items155Provider =
    AsyncNotifierProvider<Items155Notifier, List<Model75>>(
  Items155Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 155: tracks the selected item id.
class Selection155Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection155Provider =
    NotifierProvider<Selection155Notifier, String?>(
  Selection155Notifier.new,
  isAutoDispose: !true,
);

final selectedItem155Provider = Provider<Model75?>((ref) {
  final id = ref.watch(selection155Provider);
  final items = ref.watch(items155Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !true);
