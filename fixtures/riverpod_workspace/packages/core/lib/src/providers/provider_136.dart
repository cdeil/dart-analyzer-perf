import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_16.dart';
import 'package:core/src/repositories/repository_56.dart';

final repository136Provider = Provider<Repository56>(
  (ref) => Repository56(136),
  isAutoDispose: !false,
);

/// Items notifier 136: loads and edits [Model16] values.
class Items136Notifier extends AsyncNotifier<List<Model16>> {
  @override
  FutureOr<List<Model16>> build() async {
    final repository = ref.watch(repository136Provider);
    return repository.list();
  }

  Future<void> add(Model16 item) async {
    final repository = ref.read(repository136Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository136Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items136Provider =
    AsyncNotifierProvider<Items136Notifier, List<Model16>>(
  Items136Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 136: tracks the selected item id.
class Selection136Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection136Provider =
    NotifierProvider<Selection136Notifier, String?>(Selection136Notifier.new);

final selectedItem136Provider = Provider<Model16?>((ref) {
  final id = ref.watch(selection136Provider);
  final items = ref.watch(items136Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
