import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen8 extends ConsumerStatefulWidget {
  const Screen8({super.key});

  @override
  ConsumerState<Screen8> createState() => _Screen8State();
}

class _Screen8State extends ConsumerState<Screen8> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 8')),
      body: Row(
        children: [
          Expanded(child: ItemsList8(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard8()),
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
