import 'dart:async';

import 'package:core/src/models/model_25.dart';

/// Repository 25: an in-memory store with asynchronous access.
class Repository25 {
  Repository25(this.seed);

  final int seed;
  final Map<String, Model25> _items = {};

  Future<List<Model25>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model25.sortedByField2(_items.values);
  }

  Future<Model25?> find(String id) async => _items[id];

  Future<void> upsert(Model25 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
