import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_16.dart';
import 'package:core/src/repositories/repository_16.dart';

final repository96Provider = Provider<Repository16>(
  (ref) => Repository16(96),
  isAutoDispose: !false,
);

/// Items notifier 96: loads and edits [Model16] values.
class Items96Notifier extends AsyncNotifier<List<Model16>> {
  @override
  FutureOr<List<Model16>> build() async {
    final repository = ref.watch(repository96Provider);
    return repository.list();
  }

  Future<void> add(Model16 item) async {
    final repository = ref.read(repository96Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository96Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items96Provider =
    AsyncNotifierProvider<Items96Notifier, List<Model16>>(
  Items96Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 96: tracks the selected item id.
class Selection96Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection96Provider =
    NotifierProvider<Selection96Notifier, String?>(
  Selection96Notifier.new,
  isAutoDispose: !false,
);

final selectedItem96Provider = Provider<Model16?>((ref) {
  final id = ref.watch(selection96Provider);
  final items = ref.watch(items96Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
}, isAutoDispose: !false);
