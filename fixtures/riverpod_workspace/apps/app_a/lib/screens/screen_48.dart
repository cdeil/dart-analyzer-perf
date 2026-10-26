import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen48 extends ConsumerStatefulWidget {
  const Screen48({super.key});

  @override
  ConsumerState<Screen48> createState() => _Screen48State();
}

class _Screen48State extends ConsumerState<Screen48> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 48')),
      body: Row(
        children: [
          Expanded(child: ItemsList48(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard48()),
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
