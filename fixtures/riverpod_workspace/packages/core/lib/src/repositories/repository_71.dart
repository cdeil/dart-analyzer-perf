import 'dart:async';

import 'package:core/src/models/model_71.dart';

/// Repository 71: an in-memory store with asynchronous access.
class Repository71 {
  Repository71(this.seed);

  final int seed;
  final Map<String, Model71> _items = {};

  Future<List<Model71>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model71.sortedByField2(_items.values);
  }

  Future<Model71?> find(String id) async => _items[id];

  Future<void> upsert(Model71 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
