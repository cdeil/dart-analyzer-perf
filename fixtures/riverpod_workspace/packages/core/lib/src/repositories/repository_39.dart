import 'dart:async';

import 'package:core/src/models/model_39.dart';

/// Repository 39: an in-memory store with asynchronous access.
class Repository39 {
  Repository39(this.seed);

  final int seed;
  final Map<String, Model39> _items = {};

  Future<List<Model39>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model39.sortedByField2(_items.values);
  }

  Future<Model39?> find(String id) async => _items[id];

  Future<void> upsert(Model39 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
