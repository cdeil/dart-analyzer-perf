import 'dart:async';

import 'package:core/src/models/model_52.dart';

/// Repository 52: an in-memory store with asynchronous access.
class Repository52 {
  Repository52(this.seed);

  final int seed;
  final Map<String, Model52> _items = {};

  Future<List<Model52>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model52.sortedByField2(_items.values);
  }

  Future<Model52?> find(String id) async => _items[id];

  Future<void> upsert(Model52 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
