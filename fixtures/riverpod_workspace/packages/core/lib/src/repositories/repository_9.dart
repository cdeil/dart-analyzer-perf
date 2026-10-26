import 'dart:async';

import 'package:core/src/models/model_9.dart';

/// Repository 9: an in-memory store with asynchronous access.
class Repository9 {
  Repository9(this.seed);

  final int seed;
  final Map<String, Model9> _items = {};

  Future<List<Model9>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model9.sortedByField2(_items.values);
  }

  Future<Model9?> find(String id) async => _items[id];

  Future<void> upsert(Model9 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
