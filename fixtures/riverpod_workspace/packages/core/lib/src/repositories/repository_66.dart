import 'dart:async';

import 'package:core/src/models/model_66.dart';

/// Repository 66: an in-memory store with asynchronous access.
class Repository66 {
  Repository66(this.seed);

  final int seed;
  final Map<String, Model66> _items = {};

  Future<List<Model66>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model66.sortedByField2(_items.values);
  }

  Future<Model66?> find(String id) async => _items[id];

  Future<void> upsert(Model66 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
