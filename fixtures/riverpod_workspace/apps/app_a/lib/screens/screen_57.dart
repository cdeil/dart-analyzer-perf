import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen57 extends ConsumerStatefulWidget {
  const Screen57({super.key});

  @override
  ConsumerState<Screen57> createState() => _Screen57State();
}

class _Screen57State extends ConsumerState<Screen57> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 57')),
      body: Row(
        children: [
          Expanded(child: ItemsList57(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard57()),
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
