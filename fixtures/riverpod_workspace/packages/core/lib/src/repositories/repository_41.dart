import 'dart:async';

import 'package:core/src/models/model_41.dart';

/// Repository 41: an in-memory store with asynchronous access.
class Repository41 {
  Repository41(this.seed);

  final int seed;
  final Map<String, Model41> _items = {};

  Future<List<Model41>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model41.sortedByField2(_items.values);
  }

  Future<Model41?> find(String id) async => _items[id];

  Future<void> upsert(Model41 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
