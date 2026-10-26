import 'dart:async';

import 'package:core/src/models/model_58.dart';

/// Repository 58: an in-memory store with asynchronous access.
class Repository58 {
  Repository58(this.seed);

  final int seed;
  final Map<String, Model58> _items = {};

  Future<List<Model58>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model58.sortedByField2(_items.values);
  }

  Future<Model58?> find(String id) async => _items[id];

  Future<void> upsert(Model58 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
