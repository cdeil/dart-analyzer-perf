import 'dart:async';

import 'package:core/src/models/model_3.dart';

/// Repository 3: an in-memory store with asynchronous access.
class Repository3 {
  Repository3(this.seed);

  final int seed;
  final Map<String, Model3> _items = {};

  Future<List<Model3>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model3.sortedByField2(_items.values);
  }

  Future<Model3?> find(String id) async => _items[id];

  Future<void> upsert(Model3 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
