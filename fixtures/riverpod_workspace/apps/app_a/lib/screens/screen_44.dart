import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen44 extends ConsumerStatefulWidget {
  const Screen44({super.key});

  @override
  ConsumerState<Screen44> createState() => _Screen44State();
}

class _Screen44State extends ConsumerState<Screen44> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 44')),
      body: Row(
        children: [
          Expanded(child: ItemsList44(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard44()),
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
