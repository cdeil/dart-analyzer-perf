import 'dart:async';

import 'package:core/src/models/model_70.dart';

/// Repository 70: an in-memory store with asynchronous access.
class Repository70 {
  Repository70(this.seed);

  final int seed;
  final Map<String, Model70> _items = {};

  Future<List<Model70>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model70.sortedByField2(_items.values);
  }

  Future<Model70?> find(String id) async => _items[id];

  Future<void> upsert(Model70 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
