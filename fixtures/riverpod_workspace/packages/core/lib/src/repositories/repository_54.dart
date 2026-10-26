import 'dart:async';

import 'package:core/src/models/model_54.dart';

/// Repository 54: an in-memory store with asynchronous access.
class Repository54 {
  Repository54(this.seed);

  final int seed;
  final Map<String, Model54> _items = {};

  Future<List<Model54>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model54.sortedByField2(_items.values);
  }

  Future<Model54?> find(String id) async => _items[id];

  Future<void> upsert(Model54 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
