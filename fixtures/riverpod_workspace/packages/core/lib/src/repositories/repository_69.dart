import 'dart:async';

import 'package:core/src/models/model_69.dart';

/// Repository 69: an in-memory store with asynchronous access.
class Repository69 {
  Repository69(this.seed);

  final int seed;
  final Map<String, Model69> _items = {};

  Future<List<Model69>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model69.sortedByField2(_items.values);
  }

  Future<Model69?> find(String id) async => _items[id];

  Future<void> upsert(Model69 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
