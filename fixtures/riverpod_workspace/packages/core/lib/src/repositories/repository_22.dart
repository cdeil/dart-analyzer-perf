import 'dart:async';

import 'package:core/src/models/model_22.dart';

/// Repository 22: an in-memory store with asynchronous access.
class Repository22 {
  Repository22(this.seed);

  final int seed;
  final Map<String, Model22> _items = {};

  Future<List<Model22>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model22.sortedByField2(_items.values);
  }

  Future<Model22?> find(String id) async => _items[id];

  Future<void> upsert(Model22 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
