import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen32 extends ConsumerStatefulWidget {
  const Screen32({super.key});

  @override
  ConsumerState<Screen32> createState() => _Screen32State();
}

class _Screen32State extends ConsumerState<Screen32> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 32')),
      body: Row(
        children: [
          Expanded(child: ItemsList32(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard32()),
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
