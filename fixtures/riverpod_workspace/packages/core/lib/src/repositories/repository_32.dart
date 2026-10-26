import 'dart:async';

import 'package:core/src/models/model_32.dart';

/// Repository 32: an in-memory store with asynchronous access.
class Repository32 {
  Repository32(this.seed);

  final int seed;
  final Map<String, Model32> _items = {};

  Future<List<Model32>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model32.sortedByField2(_items.values);
  }

  Future<Model32?> find(String id) async => _items[id];

  Future<void> upsert(Model32 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
