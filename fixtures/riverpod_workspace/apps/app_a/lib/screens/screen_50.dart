import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen50 extends ConsumerStatefulWidget {
  const Screen50({super.key});

  @override
  ConsumerState<Screen50> createState() => _Screen50State();
}

class _Screen50State extends ConsumerState<Screen50> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 50')),
      body: Row(
        children: [
          Expanded(child: ItemsList50(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard50()),
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
