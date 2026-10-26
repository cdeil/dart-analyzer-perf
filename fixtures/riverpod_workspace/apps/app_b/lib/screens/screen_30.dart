import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen30 extends ConsumerStatefulWidget {
  const Screen30({super.key});

  @override
  ConsumerState<Screen30> createState() => _Screen30State();
}

class _Screen30State extends ConsumerState<Screen30> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 30')),
      body: Row(
        children: [
          Expanded(child: ItemsList30(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard30()),
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
