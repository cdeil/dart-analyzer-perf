import 'dart:async';

import 'package:core/src/models/model_27.dart';

/// Repository 27: an in-memory store with asynchronous access.
class Repository27 {
  Repository27(this.seed);

  final int seed;
  final Map<String, Model27> _items = {};

  Future<List<Model27>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model27.sortedByField2(_items.values);
  }

  Future<Model27?> find(String id) async => _items[id];

  Future<void> upsert(Model27 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
