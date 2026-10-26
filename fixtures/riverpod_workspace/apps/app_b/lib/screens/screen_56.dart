import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen56 extends ConsumerStatefulWidget {
  const Screen56({super.key});

  @override
  ConsumerState<Screen56> createState() => _Screen56State();
}

class _Screen56State extends ConsumerState<Screen56> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 56')),
      body: Row(
        children: [
          Expanded(child: ItemsList56(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard56()),
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
