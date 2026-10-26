import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen18 extends ConsumerStatefulWidget {
  const Screen18({super.key});

  @override
  ConsumerState<Screen18> createState() => _Screen18State();
}

class _Screen18State extends ConsumerState<Screen18> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 18')),
      body: Row(
        children: [
          Expanded(child: ItemsList18(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard18()),
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
