import 'dart:async';

import 'package:core/src/models/model_57.dart';

/// Repository 57: an in-memory store with asynchronous access.
class Repository57 {
  Repository57(this.seed);

  final int seed;
  final Map<String, Model57> _items = {};

  Future<List<Model57>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model57.sortedByField2(_items.values);
  }

  Future<Model57?> find(String id) async => _items[id];

  Future<void> upsert(Model57 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
