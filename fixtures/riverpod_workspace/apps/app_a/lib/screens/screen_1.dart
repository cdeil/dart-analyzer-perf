import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen1 extends ConsumerStatefulWidget {
  const Screen1({super.key});

  @override
  ConsumerState<Screen1> createState() => _Screen1State();
}

class _Screen1State extends ConsumerState<Screen1> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 1')),
      body: Row(
        children: [
          Expanded(child: ItemsList1(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard1()),
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
