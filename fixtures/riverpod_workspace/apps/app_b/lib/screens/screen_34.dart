import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen34 extends ConsumerStatefulWidget {
  const Screen34({super.key});

  @override
  ConsumerState<Screen34> createState() => _Screen34State();
}

class _Screen34State extends ConsumerState<Screen34> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 34')),
      body: Row(
        children: [
          Expanded(child: ItemsList34(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard34()),
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
