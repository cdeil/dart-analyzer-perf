import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen2 extends ConsumerStatefulWidget {
  const Screen2({super.key});

  @override
  ConsumerState<Screen2> createState() => _Screen2State();
}

class _Screen2State extends ConsumerState<Screen2> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 2')),
      body: Row(
        children: [
          Expanded(child: ItemsList2(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard2()),
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
