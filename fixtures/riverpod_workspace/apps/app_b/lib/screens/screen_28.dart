import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen28 extends ConsumerStatefulWidget {
  const Screen28({super.key});

  @override
  ConsumerState<Screen28> createState() => _Screen28State();
}

class _Screen28State extends ConsumerState<Screen28> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 28')),
      body: Row(
        children: [
          Expanded(child: ItemsList28(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard28()),
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
