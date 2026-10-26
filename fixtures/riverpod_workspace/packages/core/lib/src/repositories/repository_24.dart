import 'dart:async';

import 'package:core/src/models/model_24.dart';

/// Repository 24: an in-memory store with asynchronous access.
class Repository24 {
  Repository24(this.seed);

  final int seed;
  final Map<String, Model24> _items = {};

  Future<List<Model24>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model24.sortedByField2(_items.values);
  }

  Future<Model24?> find(String id) async => _items[id];

  Future<void> upsert(Model24 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
