import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen23 extends ConsumerStatefulWidget {
  const Screen23({super.key});

  @override
  ConsumerState<Screen23> createState() => _Screen23State();
}

class _Screen23State extends ConsumerState<Screen23> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 23')),
      body: Row(
        children: [
          Expanded(child: ItemsList23(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard23()),
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
