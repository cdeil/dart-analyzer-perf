import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen29 extends ConsumerStatefulWidget {
  const Screen29({super.key});

  @override
  ConsumerState<Screen29> createState() => _Screen29State();
}

class _Screen29State extends ConsumerState<Screen29> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 29')),
      body: Row(
        children: [
          Expanded(child: ItemsList29(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard29()),
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
