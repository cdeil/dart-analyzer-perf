import 'dart:async';

import 'package:core/src/models/model_65.dart';

/// Repository 65: an in-memory store with asynchronous access.
class Repository65 {
  Repository65(this.seed);

  final int seed;
  final Map<String, Model65> _items = {};

  Future<List<Model65>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model65.sortedByField2(_items.values);
  }

  Future<Model65?> find(String id) async => _items[id];

  Future<void> upsert(Model65 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
