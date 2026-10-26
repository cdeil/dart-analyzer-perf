import 'dart:async';

import 'package:core/src/models/model_53.dart';

/// Repository 53: an in-memory store with asynchronous access.
class Repository53 {
  Repository53(this.seed);

  final int seed;
  final Map<String, Model53> _items = {};

  Future<List<Model53>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model53.sortedByField2(_items.values);
  }

  Future<Model53?> find(String id) async => _items[id];

  Future<void> upsert(Model53 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
