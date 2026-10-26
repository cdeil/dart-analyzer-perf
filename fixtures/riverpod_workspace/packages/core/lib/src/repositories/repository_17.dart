import 'dart:async';

import 'package:core/src/models/model_17.dart';

/// Repository 17: an in-memory store with asynchronous access.
class Repository17 {
  Repository17(this.seed);

  final int seed;
  final Map<String, Model17> _items = {};

  Future<List<Model17>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model17.sortedByField2(_items.values);
  }

  Future<Model17?> find(String id) async => _items[id];

  Future<void> upsert(Model17 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
