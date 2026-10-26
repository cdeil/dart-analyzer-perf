import 'dart:async';

import 'package:core/src/models/model_11.dart';

/// Repository 11: an in-memory store with asynchronous access.
class Repository11 {
  Repository11(this.seed);

  final int seed;
  final Map<String, Model11> _items = {};

  Future<List<Model11>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model11.sortedByField2(_items.values);
  }

  Future<Model11?> find(String id) async => _items[id];

  Future<void> upsert(Model11 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
