import 'dart:async';

import 'package:core/src/models/model_6.dart';

/// Repository 6: an in-memory store with asynchronous access.
class Repository6 {
  Repository6(this.seed);

  final int seed;
  final Map<String, Model6> _items = {};

  Future<List<Model6>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model6.sortedByField2(_items.values);
  }

  Future<Model6?> find(String id) async => _items[id];

  Future<void> upsert(Model6 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
