import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/src/models/model_17.dart';
import 'package:core/src/repositories/repository_57.dart';

final repository137Provider = Provider<Repository57>(
  (ref) => Repository57(137),
  isAutoDispose: !false,
);

/// Items notifier 137: loads and edits [Model17] values.
class Items137Notifier extends AsyncNotifier<List<Model17>> {
  @override
  FutureOr<List<Model17>> build() async {
    final repository = ref.watch(repository137Provider);
    return repository.list();
  }

  Future<void> add(Model17 item) async {
    final repository = ref.read(repository137Provider);
    await repository.upsert(item);
    ref.invalidateSelf();
  }

  Future<void> remove(String id) async {
    final repository = ref.read(repository137Provider);
    await repository.remove(id);
    ref.invalidateSelf();
  }
}

final items137Provider =
    AsyncNotifierProvider<Items137Notifier, List<Model17>>(
  Items137Notifier.new,
  isAutoDispose: !false,
);

/// Selection notifier 137: tracks the selected item id.
class Selection137Notifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;

  void clear() => state = null;
}

final selection137Provider =
    NotifierProvider<Selection137Notifier, String?>(Selection137Notifier.new);

final selectedItem137Provider = Provider<Model17?>((ref) {
  final id = ref.watch(selection137Provider);
  final items = ref.watch(items137Provider).value ?? const [];
  if (id == null) return null;
  for (final item in items) {
    if (item.field1 == id) return item;
  }
  return null;
});
