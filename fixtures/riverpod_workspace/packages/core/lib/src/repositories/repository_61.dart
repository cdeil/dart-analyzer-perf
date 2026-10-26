import 'dart:async';

import 'package:core/src/models/model_61.dart';

/// Repository 61: an in-memory store with asynchronous access.
class Repository61 {
  Repository61(this.seed);

  final int seed;
  final Map<String, Model61> _items = {};

  Future<List<Model61>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model61.sortedByField2(_items.values);
  }

  Future<Model61?> find(String id) async => _items[id];

  Future<void> upsert(Model61 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
