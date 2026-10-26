import 'dart:async';

import 'package:core/src/models/model_72.dart';

/// Repository 72: an in-memory store with asynchronous access.
class Repository72 {
  Repository72(this.seed);

  final int seed;
  final Map<String, Model72> _items = {};

  Future<List<Model72>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model72.sortedByField2(_items.values);
  }

  Future<Model72?> find(String id) async => _items[id];

  Future<void> upsert(Model72 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
