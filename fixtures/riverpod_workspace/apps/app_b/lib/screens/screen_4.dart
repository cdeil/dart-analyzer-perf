import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen4 extends ConsumerStatefulWidget {
  const Screen4({super.key});

  @override
  ConsumerState<Screen4> createState() => _Screen4State();
}

class _Screen4State extends ConsumerState<Screen4> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 4')),
      body: Row(
        children: [
          Expanded(child: ItemsList4(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard4()),
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
