import 'dart:async';

import 'package:core/src/models/model_74.dart';

/// Repository 74: an in-memory store with asynchronous access.
class Repository74 {
  Repository74(this.seed);

  final int seed;
  final Map<String, Model74> _items = {};

  Future<List<Model74>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model74.sortedByField2(_items.values);
  }

  Future<Model74?> find(String id) async => _items[id];

  Future<void> upsert(Model74 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
