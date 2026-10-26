import 'dart:async';

import 'package:core/src/models/model_62.dart';

/// Repository 62: an in-memory store with asynchronous access.
class Repository62 {
  Repository62(this.seed);

  final int seed;
  final Map<String, Model62> _items = {};

  Future<List<Model62>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model62.sortedByField2(_items.values);
  }

  Future<Model62?> find(String id) async => _items[id];

  Future<void> upsert(Model62 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
