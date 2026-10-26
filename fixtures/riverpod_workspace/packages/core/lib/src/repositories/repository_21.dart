import 'dart:async';

import 'package:core/src/models/model_21.dart';

/// Repository 21: an in-memory store with asynchronous access.
class Repository21 {
  Repository21(this.seed);

  final int seed;
  final Map<String, Model21> _items = {};

  Future<List<Model21>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model21.sortedByField2(_items.values);
  }

  Future<Model21?> find(String id) async => _items[id];

  Future<void> upsert(Model21 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
