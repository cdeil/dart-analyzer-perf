import 'dart:async';

import 'package:core/src/models/model_0.dart';

/// Repository 0: an in-memory store with asynchronous access.
class Repository0 {
  Repository0(this.seed);

  final int seed;
  final Map<String, Model0> _items = {};

  Future<List<Model0>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model0.sortedByField2(_items.values);
  }

  Future<Model0?> find(String id) async => _items[id];

  Future<void> upsert(Model0 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
