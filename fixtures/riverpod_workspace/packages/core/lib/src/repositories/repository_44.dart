import 'dart:async';

import 'package:core/src/models/model_44.dart';

/// Repository 44: an in-memory store with asynchronous access.
class Repository44 {
  Repository44(this.seed);

  final int seed;
  final Map<String, Model44> _items = {};

  Future<List<Model44>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model44.sortedByField2(_items.values);
  }

  Future<Model44?> find(String id) async => _items[id];

  Future<void> upsert(Model44 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
