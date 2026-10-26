import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen27 extends ConsumerStatefulWidget {
  const Screen27({super.key});

  @override
  ConsumerState<Screen27> createState() => _Screen27State();
}

class _Screen27State extends ConsumerState<Screen27> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 27')),
      body: Row(
        children: [
          Expanded(child: ItemsList27(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard27()),
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
