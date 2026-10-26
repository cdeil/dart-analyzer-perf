import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_16.dart';
import 'package:core/src/repositories/repository_16.dart';

final repository16Provider = Provider<Repository16>(
  (ref) => Repository16(16),
  isAutoDispose: !false,
);

/// Items notifier 16: loads and edits [Model16] values.
class Items16Notifier extends AsyncNotifier<List<Model16>> {
  @override
  FutureOr<List<Model16>> build() async {
    final repository = ref.watch(repository16Provider);
    return repository.list();
  }

  Future<void> add(Model16 item) async {
    final repository = ref.read(repository16Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository16Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items16Provider =
    AsyncNotifierProvider<Items16Notifier, List<Model16>>(
  Items16Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 16: tracks the selected item id.
class Selection16Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection16Provider =
    NotifierProvider<Selection16Notifier, String?>(Selection16Notifier.new);

final selectedItem16Provider = Provider<Model16?>((ref) {
  final id = ref.watch(selection16Provider);
  final items = ref.watch(items16Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
