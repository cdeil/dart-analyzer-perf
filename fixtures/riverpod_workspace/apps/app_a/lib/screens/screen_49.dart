import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen49 extends ConsumerStatefulWidget {
  const Screen49({super.key});

  @override
  ConsumerState<Screen49> createState() => _Screen49State();
}

class _Screen49State extends ConsumerState<Screen49> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 49')),
      body: Row(
        children: [
          Expanded(child: ItemsList49(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard49()),
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
