import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen26 extends ConsumerStatefulWidget {
  const Screen26({super.key});

  @override
  ConsumerState<Screen26> createState() => _Screen26State();
}

class _Screen26State extends ConsumerState<Screen26> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 26')),
      body: Row(
        children: [
          Expanded(child: ItemsList26(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard26()),
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
