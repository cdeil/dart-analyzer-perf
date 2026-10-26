import 'dart:async';

import 'package:core/src/models/model_46.dart';

/// Repository 46: an in-memory store with asynchronous access.
class Repository46 {
  Repository46(this.seed);

  final int seed;
  final Map<String, Model46> _items = {};

  Future<List<Model46>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model46.sortedByField2(_items.values);
  }

  Future<Model46?> find(String id) async => _items[id];

  Future<void> upsert(Model46 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
