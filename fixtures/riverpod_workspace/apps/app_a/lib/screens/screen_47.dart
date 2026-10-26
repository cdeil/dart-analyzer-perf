import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen47 extends ConsumerStatefulWidget {
  const Screen47({super.key});

  @override
  ConsumerState<Screen47> createState() => _Screen47State();
}

class _Screen47State extends ConsumerState<Screen47> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 47')),
      body: Row(
        children: [
          Expanded(child: ItemsList47(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard47()),
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
