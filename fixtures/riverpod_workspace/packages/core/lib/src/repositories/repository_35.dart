import 'dart:async';

import 'package:core/src/models/model_35.dart';

/// Repository 35: an in-memory store with asynchronous access.
class Repository35 {
  Repository35(this.seed);

  final int seed;
  final Map<String, Model35> _items = {};

  Future<List<Model35>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model35.sortedByField2(_items.values);
  }

  Future<Model35?> find(String id) async => _items[id];

  Future<void> upsert(Model35 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
