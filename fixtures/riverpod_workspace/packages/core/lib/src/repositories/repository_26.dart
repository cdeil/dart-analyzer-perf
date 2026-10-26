import 'dart:async';

import 'package:core/src/models/model_26.dart';

/// Repository 26: an in-memory store with asynchronous access.
class Repository26 {
  Repository26(this.seed);

  final int seed;
  final Map<String, Model26> _items = {};

  Future<List<Model26>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model26.sortedByField2(_items.values);
  }

  Future<Model26?> find(String id) async => _items[id];

  Future<void> upsert(Model26 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
