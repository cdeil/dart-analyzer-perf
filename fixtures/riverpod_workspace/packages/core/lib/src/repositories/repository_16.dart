import 'dart:async';

import 'package:core/src/models/model_16.dart';

/// Repository 16: an in-memory store with asynchronous access.
class Repository16 {
  Repository16(this.seed);

  final int seed;
  final Map<String, Model16> _items = {};

  Future<List<Model16>> list() async {
    await Future<void>.delayed(const Duration(milliseconds: 1));
    return Model16.sortedByField2(_items.values);
  }

  Future<Model16?> find(String id) async => _items[id];

  Future<void> upsert(Model16 item) async {
    _items[item.field1] = item;
  }

  Future<void> remove(String id) async {
    _items.remove(id);
  }

  Stream<int> count() async* {
    yield _items.length;
  }
}
