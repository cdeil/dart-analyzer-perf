import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_25.dart';
import 'package:core/src/repositories/repository_65.dart';

final repository145Provider = Provider<Repository65>(
  (ref) => Repository65(145),
  isAutoDispose: !true,
);

/// Items notifier 145: loads and edits [Model25] values.
class Items145Notifier extends AsyncNotifier<List<Model25>> {
  @override
  FutureOr<List<Model25>> build() async {
    final repository = ref.watch(repository145Provider);
    return repository.list();
  }

  Future<void> add(Model25 item) async {
    final repository = ref.read(repository145Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository145Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items145Provider =
    AsyncNotifierProvider<Items145Notifier, List<Model25>>(
  Items145Notifier.new,
  isAutoDispose: !true,
);

/// Selection notifier 145: tracks the selected item id.
class Selection145Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection145Provider =
    NotifierProvider<Selection145Notifier, String?>(Selection145Notifier.new);

final selectedItem145Provider = Provider<Model25?>((ref) {
  final id = ref.watch(selection145Provider);
  final items = ref.watch(items145Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
