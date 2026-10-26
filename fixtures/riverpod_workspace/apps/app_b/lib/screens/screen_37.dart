import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen37 extends ConsumerStatefulWidget {
  const Screen37({super.key});

  @override
  ConsumerState<Screen37> createState() => _Screen37State();
}

class _Screen37State extends ConsumerState<Screen37> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 37')),
      body: Row(
        children: [
          Expanded(child: ItemsList37(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard37()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: ${_selected ?? 'none'}')),
        ),
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
