import 'dart:async';

import 'package:core/src/models/model_10.dart';

/// Repository 10: an in-memory store with asynchronous access.
class Repository10 {
  Repository10(this.seed);

  final int seed;
  final Map<String, Model10> _items = {};

  Future<List<Model10>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model10.sortedByField2(_items.values);
  }

  Future<Model10?> find(String id) async => _items[id];

  Future<void> upsert(Model10 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
