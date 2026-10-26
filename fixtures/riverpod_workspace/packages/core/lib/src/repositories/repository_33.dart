import 'dart:async';

import 'package:core/src/models/model_33.dart';

/// Repository 33: an in-memory store with asynchronous access.
class Repository33 {
  Repository33(this.seed);

  final int seed;
  final Map<String, Model33> _items = {};

  Future<List<Model33>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model33.sortedByField2(_items.values);
  }

  Future<Model33?> find(String id) async => _items[id];

  Future<void> upsert(Model33 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
