import 'dart:async';

import 'package:core/src/models/model_51.dart';

/// Repository 51: an in-memory store with asynchronous access.
class Repository51 {
  Repository51(this.seed);

  final int seed;
  final Map<String, Model51> _items = {};

  Future<List<Model51>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model51.sortedByField2(_items.values);
  }

  Future<Model51?> find(String id) async => _items[id];

  Future<void> upsert(Model51 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
