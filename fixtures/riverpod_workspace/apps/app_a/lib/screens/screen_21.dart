import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen21 extends ConsumerStatefulWidget {
  const Screen21({super.key});

  @override
  ConsumerState<Screen21> createState() => _Screen21State();
}

class _Screen21State extends ConsumerState<Screen21> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 21')),
      body: Row(
        children: [
          Expanded(child: ItemsList21(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard21()),
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
