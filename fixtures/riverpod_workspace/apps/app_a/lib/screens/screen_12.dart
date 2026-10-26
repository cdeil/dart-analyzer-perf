import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen12 extends ConsumerStatefulWidget {
  const Screen12({super.key});

  @override
  ConsumerState<Screen12> createState() => _Screen12State();
}

class _Screen12State extends ConsumerState<Screen12> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 12')),
      body: Row(
        children: [
          Expanded(child: ItemsList12(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard12()),
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
