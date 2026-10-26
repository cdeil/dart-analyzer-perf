import 'dart:async';

import 'package:core/src/models/model_14.dart';

/// Repository 14: an in-memory store with asynchronous access.
class Repository14 {
  Repository14(this.seed);

  final int seed;
  final Map<String, Model14> _items = {};

  Future<List<Model14>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model14.sortedByField2(_items.values);
  }

  Future<Model14?> find(String id) async => _items[id];

  Future<void> upsert(Model14 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
