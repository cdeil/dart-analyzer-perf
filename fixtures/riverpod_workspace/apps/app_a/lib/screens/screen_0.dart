import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen0 extends ConsumerStatefulWidget {
  const Screen0({super.key});

  @override
  ConsumerState<Screen0> createState() => _Screen0State();
}

class _Screen0State extends ConsumerState<Screen0> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 0')),
      body: Row(
        children: [
          Expanded(child: ItemsList0(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard0()),
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
