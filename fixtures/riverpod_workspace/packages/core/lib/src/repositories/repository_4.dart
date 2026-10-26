import 'dart:async';

import 'package:core/src/models/model_4.dart';

/// Repository 4: an in-memory store with asynchronous access.
class Repository4 {
  Repository4(this.seed);

  final int seed;
  final Map<String, Model4> _items = {};

  Future<List<Model4>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model4.sortedByField2(_items.values);
  }

  Future<Model4?> find(String id) async => _items[id];

  Future<void> upsert(Model4 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
