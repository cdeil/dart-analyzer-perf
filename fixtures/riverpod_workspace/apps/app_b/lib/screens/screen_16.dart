import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen16 extends ConsumerStatefulWidget {
  const Screen16({super.key});

  @override
  ConsumerState<Screen16> createState() => _Screen16State();
}

class _Screen16State extends ConsumerState<Screen16> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 16')),
      body: Row(
        children: [
          Expanded(child: ItemsList16(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard16()),
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
