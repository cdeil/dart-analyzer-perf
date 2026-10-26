import 'dart:async';

import 'package:core/src/models/model_28.dart';

/// Repository 28: an in-memory store with asynchronous access.
class Repository28 {
  Repository28(this.seed);

  final int seed;
  final Map<String, Model28> _items = {};

  Future<List<Model28>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model28.sortedByField2(_items.values);
  }

  Future<Model28?> find(String id) async => _items[id];

  Future<void> upsert(Model28 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
