import 'dart:async';

import 'package:core/src/models/model_1.dart';

/// Repository 1: an in-memory store with asynchronous access.
class Repository1 {
  Repository1(this.seed);

  final int seed;
  final Map<String, Model1> _items = {};

  Future<List<Model1>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model1.sortedByField2(_items.values);
  }

  Future<Model1?> find(String id) async => _items[id];

  Future<void> upsert(Model1 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
