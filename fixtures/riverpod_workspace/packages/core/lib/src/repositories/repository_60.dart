import 'dart:async';

import 'package:core/src/models/model_60.dart';

/// Repository 60: an in-memory store with asynchronous access.
class Repository60 {
  Repository60(this.seed);

  final int seed;
  final Map<String, Model60> _items = {};

  Future<List<Model60>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model60.sortedByField2(_items.values);
  }

  Future<Model60?> find(String id) async => _items[id];

  Future<void> upsert(Model60 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
