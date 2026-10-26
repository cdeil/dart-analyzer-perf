import 'dart:async';

import 'package:core/src/models/model_18.dart';

/// Repository 18: an in-memory store with asynchronous access.
class Repository18 {
  Repository18(this.seed);

  final int seed;
  final Map<String, Model18> _items = {};

  Future<List<Model18>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model18.sortedByField2(_items.values);
  }

  Future<Model18?> find(String id) async => _items[id];

  Future<void> upsert(Model18 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
