import 'dart:async';

import 'package:core/src/models/model_47.dart';

/// Repository 47: an in-memory store with asynchronous access.
class Repository47 {
  Repository47(this.seed);

  final int seed;
  final Map<String, Model47> _items = {};

  Future<List<Model47>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model47.sortedByField2(_items.values);
  }

  Future<Model47?> find(String id) async => _items[id];

  Future<void> upsert(Model47 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
