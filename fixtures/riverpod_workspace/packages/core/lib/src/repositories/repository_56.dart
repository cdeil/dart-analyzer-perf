import 'dart:async';

import 'package:core/src/models/model_56.dart';

/// Repository 56: an in-memory store with asynchronous access.
class Repository56 {
  Repository56(this.seed);

  final int seed;
  final Map<String, Model56> _items = {};

  Future<List<Model56>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model56.sortedByField2(_items.values);
  }

  Future<Model56?> find(String id) async => _items[id];

  Future<void> upsert(Model56 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
