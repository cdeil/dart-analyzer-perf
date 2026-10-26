import 'dart:async';

import 'package:core/src/models/model_59.dart';

/// Repository 59: an in-memory store with asynchronous access.
class Repository59 {
  Repository59(this.seed);

  final int seed;
  final Map<String, Model59> _items = {};

  Future<List<Model59>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model59.sortedByField2(_items.values);
  }

  Future<Model59?> find(String id) async => _items[id];

  Future<void> upsert(Model59 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
