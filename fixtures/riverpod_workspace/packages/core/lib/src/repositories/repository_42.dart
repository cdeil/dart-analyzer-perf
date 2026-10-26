import 'dart:async';

import 'package:core/src/models/model_42.dart';

/// Repository 42: an in-memory store with asynchronous access.
class Repository42 {
  Repository42(this.seed);

  final int seed;
  final Map<String, Model42> _items = {};

  Future<List<Model42>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model42.sortedByField2(_items.values);
  }

  Future<Model42?> find(String id) async => _items[id];

  Future<void> upsert(Model42 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
