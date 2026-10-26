import 'dart:async';

import 'package:core/src/models/model_30.dart';

/// Repository 30: an in-memory store with asynchronous access.
class Repository30 {
  Repository30(this.seed);

  final int seed;
  final Map<String, Model30> _items = {};

  Future<List<Model30>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model30.sortedByField2(_items.values);
  }

  Future<Model30?> find(String id) async => _items[id];

  Future<void> upsert(Model30 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
