import 'dart:async';

import 'package:core/src/models/model_48.dart';

/// Repository 48: an in-memory store with asynchronous access.
class Repository48 {
  Repository48(this.seed);

  final int seed;
  final Map<String, Model48> _items = {};

  Future<List<Model48>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model48.sortedByField2(_items.values);
  }

  Future<Model48?> find(String id) async => _items[id];

  Future<void> upsert(Model48 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
