import 'dart:async';

import 'package:core/src/models/model_5.dart';

/// Repository 5: an in-memory store with asynchronous access.
class Repository5 {
  Repository5(this.seed);

  final int seed;
  final Map<String, Model5> _items = {};

  Future<List<Model5>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model5.sortedByField2(_items.values);
  }

  Future<Model5?> find(String id) async => _items[id];

  Future<void> upsert(Model5 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
