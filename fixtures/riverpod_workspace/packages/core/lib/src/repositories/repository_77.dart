import 'dart:async';

import 'package:core/src/models/model_77.dart';

/// Repository 77: an in-memory store with asynchronous access.
class Repository77 {
  Repository77(this.seed);

  final int seed;
  final Map<String, Model77> _items = {};

  Future<List<Model77>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model77.sortedByField2(_items.values);
  }

  Future<Model77?> find(String id) async => _items[id];

  Future<void> upsert(Model77 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
