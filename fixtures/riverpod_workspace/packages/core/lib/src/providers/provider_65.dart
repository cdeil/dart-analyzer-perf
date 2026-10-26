import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_65.dart';
import 'package:core/src/repositories/repository_65.dart';

final repository65Provider = Provider<Repository65>(
  (ref) => Repository65(65),
  isAutoDispose: !true,
);

/// Items notifier 65: loads and edits [Model65] values.
class Items65Notifier extends AsyncNotifier<List<Model65>> {
  @override
  FutureOr<List<Model65>> build() async {
    final repository = ref.watch(repository65Provider);
    return repository.list();
  }

  Future<void> add(Model65 item) async {
    final repository = ref.read(repository65Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository65Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items65Provider =
    AsyncNotifierProvider<Items65Notifier, List<Model65>>(
  Items65Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 65: tracks the selected item id.
class Selection65Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection65Provider =
    NotifierProvider<Selection65Notifier, String?>(Selection65Notifier.new);

final selectedItem65Provider = Provider<Model65?>((ref) {
  final id = ref.watch(selection65Provider);
  final items = ref.watch(items65Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
