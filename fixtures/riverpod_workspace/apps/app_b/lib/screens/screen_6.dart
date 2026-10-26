import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen6 extends ConsumerStatefulWidget {
  const Screen6({super.key});

  @override
  ConsumerState<Screen6> createState() => _Screen6State();
}

class _Screen6State extends ConsumerState<Screen6> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 6')),
      body: Row(
        children: [
          Expanded(child: ItemsList6(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard6()),
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
