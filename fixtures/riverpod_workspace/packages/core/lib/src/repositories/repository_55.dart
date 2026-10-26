import 'dart:async';

import 'package:core/src/models/model_55.dart';

/// Repository 55: an in-memory store with asynchronous access.
class Repository55 {
  Repository55(this.seed);

  final int seed;
  final Map<String, Model55> _items = {};

  Future<List<Model55>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model55.sortedByField2(_items.values);
  }

  Future<Model55?> find(String id) async => _items[id];

  Future<void> upsert(Model55 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
