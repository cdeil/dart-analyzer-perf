import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen10 extends ConsumerStatefulWidget {
  const Screen10({super.key});

  @override
  ConsumerState<Screen10> createState() => _Screen10State();
}

class _Screen10State extends ConsumerState<Screen10> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 10')),
      body: Row(
        children: [
          Expanded(child: ItemsList10(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard10()),
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
