import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen58 extends ConsumerStatefulWidget {
  const Screen58({super.key});

  @override
  ConsumerState<Screen58> createState() => _Screen58State();
}

class _Screen58State extends ConsumerState<Screen58> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 58')),
      body: Row(
        children: [
          Expanded(child: ItemsList58(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard58()),
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
