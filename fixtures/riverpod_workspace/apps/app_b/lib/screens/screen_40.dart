import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen40 extends ConsumerStatefulWidget {
  const Screen40({super.key});

  @override
  ConsumerState<Screen40> createState() => _Screen40State();
}

class _Screen40State extends ConsumerState<Screen40> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 40')),
      body: Row(
        children: [
          Expanded(child: ItemsList40(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard40()),
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
