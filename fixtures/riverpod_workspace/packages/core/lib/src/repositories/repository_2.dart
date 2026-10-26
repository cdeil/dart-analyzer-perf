import 'dart:async';

import 'package:core/src/models/model_2.dart';

/// Repository 2: an in-memory store with asynchronous access.
class Repository2 {
  Repository2(this.seed);

  final int seed;
  final Map<String, Model2> _items = {};

  Future<List<Model2>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model2.sortedByField2(_items.values);
  }

  Future<Model2?> find(String id) async => _items[id];

  Future<void> upsert(Model2 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
