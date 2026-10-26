import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen43 extends ConsumerStatefulWidget {
  const Screen43({super.key});

  @override
  ConsumerState<Screen43> createState() => _Screen43State();
}

class _Screen43State extends ConsumerState<Screen43> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 43')),
      body: Row(
        children: [
          Expanded(child: ItemsList43(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard43()),
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
