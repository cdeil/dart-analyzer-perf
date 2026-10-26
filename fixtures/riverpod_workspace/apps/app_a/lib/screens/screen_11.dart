import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen11 extends ConsumerStatefulWidget {
  const Screen11({super.key});

  @override
  ConsumerState<Screen11> createState() => _Screen11State();
}

class _Screen11State extends ConsumerState<Screen11> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 11')),
      body: Row(
        children: [
          Expanded(child: ItemsList11(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard11()),
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
