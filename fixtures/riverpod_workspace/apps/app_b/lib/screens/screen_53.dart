import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen53 extends ConsumerStatefulWidget {
  const Screen53({super.key});

  @override
  ConsumerState<Screen53> createState() => _Screen53State();
}

class _Screen53State extends ConsumerState<Screen53> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 53')),
      body: Row(
        children: [
          Expanded(child: ItemsList53(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard53()),
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
