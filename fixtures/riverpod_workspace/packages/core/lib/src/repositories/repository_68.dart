import 'dart:async';

import 'package:core/src/models/model_68.dart';

/// Repository 68: an in-memory store with asynchronous access.
class Repository68 {
  Repository68(this.seed);

  final int seed;
  final Map<String, Model68> _items = {};

  Future<List<Model68>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model68.sortedByField2(_items.values);
  }

  Future<Model68?> find(String id) async => _items[id];

  Future<void> upsert(Model68 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
