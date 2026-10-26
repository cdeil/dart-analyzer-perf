import 'dart:async';

import 'package:core/src/models/model_36.dart';

/// Repository 36: an in-memory store with asynchronous access.
class Repository36 {
  Repository36(this.seed);

  final int seed;
  final Map<String, Model36> _items = {};

  Future<List<Model36>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model36.sortedByField2(_items.values);
  }

  Future<Model36?> find(String id) async => _items[id];

  Future<void> upsert(Model36 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
