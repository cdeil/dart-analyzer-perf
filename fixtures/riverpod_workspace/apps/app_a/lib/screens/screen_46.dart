import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen46 extends ConsumerStatefulWidget {
  const Screen46({super.key});

  @override
  ConsumerState<Screen46> createState() => _Screen46State();
}

class _Screen46State extends ConsumerState<Screen46> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 46')),
      body: Row(
        children: [
          Expanded(child: ItemsList46(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard46()),
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
