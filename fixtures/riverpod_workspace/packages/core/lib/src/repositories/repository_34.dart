import 'dart:async';

import 'package:core/src/models/model_34.dart';

/// Repository 34: an in-memory store with asynchronous access.
class Repository34 {
  Repository34(this.seed);

  final int seed;
  final Map<String, Model34> _items = {};

  Future<List<Model34>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model34.sortedByField2(_items.values);
  }

  Future<Model34?> find(String id) async => _items[id];

  Future<void> upsert(Model34 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
