import 'dart:async';

import 'package:core/src/models/model_75.dart';

/// Repository 75: an in-memory store with asynchronous access.
class Repository75 {
  Repository75(this.seed);

  final int seed;
  final Map<String, Model75> _items = {};

  Future<List<Model75>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model75.sortedByField2(_items.values);
  }

  Future<Model75?> find(String id) async => _items[id];

  Future<void> upsert(Model75 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
