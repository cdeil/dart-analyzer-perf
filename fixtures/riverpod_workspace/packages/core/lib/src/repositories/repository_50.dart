import 'dart:async';

import 'package:core/src/models/model_50.dart';

/// Repository 50: an in-memory store with asynchronous access.
class Repository50 {
  Repository50(this.seed);

  final int seed;
  final Map<String, Model50> _items = {};

  Future<List<Model50>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model50.sortedByField2(_items.values);
  }

  Future<Model50?> find(String id) async => _items[id];

  Future<void> upsert(Model50 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
