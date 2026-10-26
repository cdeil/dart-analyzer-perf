import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen17 extends ConsumerStatefulWidget {
  const Screen17({super.key});

  @override
  ConsumerState<Screen17> createState() => _Screen17State();
}

class _Screen17State extends ConsumerState<Screen17> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 17')),
      body: Row(
        children: [
          Expanded(child: ItemsList17(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard17()),
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
