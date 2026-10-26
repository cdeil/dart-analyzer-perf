import 'dart:async';

import 'package:core/src/models/model_73.dart';

/// Repository 73: an in-memory store with asynchronous access.
class Repository73 {
  Repository73(this.seed);

  final int seed;
  final Map<String, Model73> _items = {};

  Future<List<Model73>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model73.sortedByField2(_items.values);
  }

  Future<Model73?> find(String id) async => _items[id];

  Future<void> upsert(Model73 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
