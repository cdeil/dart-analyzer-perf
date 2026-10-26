import 'dart:async';

import 'package:core/src/models/model_63.dart';

/// Repository 63: an in-memory store with asynchronous access.
class Repository63 {
  Repository63(this.seed);

  final int seed;
  final Map<String, Model63> _items = {};

  Future<List<Model63>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model63.sortedByField2(_items.values);
  }

  Future<Model63?> find(String id) async => _items[id];

  Future<void> upsert(Model63 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
