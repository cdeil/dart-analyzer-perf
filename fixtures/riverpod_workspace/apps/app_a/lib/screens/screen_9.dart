import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen9 extends ConsumerStatefulWidget {
  const Screen9({super.key});

  @override
  ConsumerState<Screen9> createState() => _Screen9State();
}

class _Screen9State extends ConsumerState<Screen9> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 9')),
      body: Row(
        children: [
          Expanded(child: ItemsList9(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard9()),
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
