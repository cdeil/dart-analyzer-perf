import 'dart:async';

import 'package:core/src/models/model_64.dart';

/// Repository 64: an in-memory store with asynchronous access.
class Repository64 {
  Repository64(this.seed);

  final int seed;
  final Map<String, Model64> _items = {};

  Future<List<Model64>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model64.sortedByField2(_items.values);
  }

  Future<Model64?> find(String id) async => _items[id];

  Future<void> upsert(Model64 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
