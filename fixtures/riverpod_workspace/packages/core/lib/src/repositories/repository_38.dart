import 'dart:async';

import 'package:core/src/models/model_38.dart';

/// Repository 38: an in-memory store with asynchronous access.
class Repository38 {
  Repository38(this.seed);

  final int seed;
  final Map<String, Model38> _items = {};

  Future<List<Model38>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model38.sortedByField2(_items.values);
  }

  Future<Model38?> find(String id) async => _items[id];

  Future<void> upsert(Model38 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
