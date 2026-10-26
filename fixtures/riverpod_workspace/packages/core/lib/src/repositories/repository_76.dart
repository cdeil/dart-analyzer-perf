import 'dart:async';

import 'package:core/src/models/model_76.dart';

/// Repository 76: an in-memory store with asynchronous access.
class Repository76 {
  Repository76(this.seed);

  final int seed;
  final Map<String, Model76> _items = {};

  Future<List<Model76>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model76.sortedByField2(_items.values);
  }

  Future<Model76?> find(String id) async => _items[id];

  Future<void> upsert(Model76 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
