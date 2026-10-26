import 'dart:async';

import 'package:core/src/models/model_19.dart';

/// Repository 19: an in-memory store with asynchronous access.
class Repository19 {
  Repository19(this.seed);

  final int seed;
  final Map<String, Model19> _items = {};

  Future<List<Model19>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model19.sortedByField2(_items.values);
  }

  Future<Model19?> find(String id) async => _items[id];

  Future<void> upsert(Model19 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
