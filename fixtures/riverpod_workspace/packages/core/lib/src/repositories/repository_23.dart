import 'dart:async';

import 'package:core/src/models/model_23.dart';

/// Repository 23: an in-memory store with asynchronous access.
class Repository23 {
  Repository23(this.seed);

  final int seed;
  final Map<String, Model23> _items = {};

  Future<List<Model23>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model23.sortedByField2(_items.values);
  }

  Future<Model23?> find(String id) async => _items[id];

  Future<void> upsert(Model23 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
