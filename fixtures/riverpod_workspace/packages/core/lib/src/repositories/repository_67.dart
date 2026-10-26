import 'dart:async';

import 'package:core/src/models/model_67.dart';

/// Repository 67: an in-memory store with asynchronous access.
class Repository67 {
  Repository67(this.seed);

  final int seed;
  final Map<String, Model67> _items = {};

  Future<List<Model67>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model67.sortedByField2(_items.values);
  }

  Future<Model67?> find(String id) async => _items[id];

  Future<void> upsert(Model67 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
