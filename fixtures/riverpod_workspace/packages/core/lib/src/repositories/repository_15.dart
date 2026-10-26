import 'dart:async';

import 'package:core/src/models/model_15.dart';

/// Repository 15: an in-memory store with asynchronous access.
class Repository15 {
  Repository15(this.seed);

  final int seed;
  final Map<String, Model15> _items = {};

  Future<List<Model15>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model15.sortedByField2(_items.values);
  }

  Future<Model15?> find(String id) async => _items[id];

  Future<void> upsert(Model15 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
