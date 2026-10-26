import 'dart:async';

import 'package:core/src/models/model_49.dart';

/// Repository 49: an in-memory store with asynchronous access.
class Repository49 {
  Repository49(this.seed);

  final int seed;
  final Map<String, Model49> _items = {};

  Future<List<Model49>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model49.sortedByField2(_items.values);
  }

  Future<Model49?> find(String id) async => _items[id];

  Future<void> upsert(Model49 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
