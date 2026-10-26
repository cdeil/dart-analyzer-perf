import 'dart:async';

import 'package:core/src/models/model_79.dart';

/// Repository 79: an in-memory store with asynchronous access.
class Repository79 {
  Repository79(this.seed);

  final int seed;
  final Map<String, Model79> _items = {};

  Future<List<Model79>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model79.sortedByField2(_items.values);
  }

  Future<Model79?> find(String id) async => _items[id];

  Future<void> upsert(Model79 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
