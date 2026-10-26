import 'dart:async';

import 'package:core/src/models/model_78.dart';

/// Repository 78: an in-memory store with asynchronous access.
class Repository78 {
  Repository78(this.seed);

  final int seed;
  final Map<String, Model78> _items = {};

  Future<List<Model78>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model78.sortedByField2(_items.values);
  }

  Future<Model78?> find(String id) async => _items[id];

  Future<void> upsert(Model78 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
