import 'dart:async';

import 'package:core/src/models/model_31.dart';

/// Repository 31: an in-memory store with asynchronous access.
class Repository31 {
  Repository31(this.seed);

  final int seed;
  final Map<String, Model31> _items = {};

  Future<List<Model31>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model31.sortedByField2(_items.values);
  }

  Future<Model31?> find(String id) async => _items[id];

  Future<void> upsert(Model31 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
