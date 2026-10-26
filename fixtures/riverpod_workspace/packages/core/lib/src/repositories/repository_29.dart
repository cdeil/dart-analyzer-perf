import 'dart:async';

import 'package:core/src/models/model_29.dart';

/// Repository 29: an in-memory store with asynchronous access.
class Repository29 {
  Repository29(this.seed);

  final int seed;
  final Map<String, Model29> _items = {};

  Future<List<Model29>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model29.sortedByField2(_items.values);
  }

  Future<Model29?> find(String id) async => _items[id];

  Future<void> upsert(Model29 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
