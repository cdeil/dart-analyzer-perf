import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen36 extends ConsumerStatefulWidget {
  const Screen36({super.key});

  @override
  ConsumerState<Screen36> createState() => _Screen36State();
}

class _Screen36State extends ConsumerState<Screen36> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 36')),
      body: Row(
        children: [
          Expanded(child: ItemsList36(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard36()),
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
