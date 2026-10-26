import 'dart:async';

import 'package:core/src/models/model_40.dart';

/// Repository 40: an in-memory store with asynchronous access.
class Repository40 {
  Repository40(this.seed);

  final int seed;
  final Map<String, Model40> _items = {};

  Future<List<Model40>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model40.sortedByField2(_items.values);
  }

  Future<Model40?> find(String id) async => _items[id];

  Future<void> upsert(Model40 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
