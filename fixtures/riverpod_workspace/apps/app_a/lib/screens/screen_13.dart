import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen13 extends ConsumerStatefulWidget {
  const Screen13({super.key});

  @override
  ConsumerState<Screen13> createState() => _Screen13State();
}

class _Screen13State extends ConsumerState<Screen13> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 13')),
      body: Row(
        children: [
          Expanded(child: ItemsList13(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard13()),
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
