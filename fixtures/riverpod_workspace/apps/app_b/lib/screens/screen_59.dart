import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen59 extends ConsumerStatefulWidget {
  const Screen59({super.key});

  @override
  ConsumerState<Screen59> createState() => _Screen59State();
}

class _Screen59State extends ConsumerState<Screen59> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 59')),
      body: Row(
        children: [
          Expanded(child: ItemsList59(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard59()),
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
