import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen7 extends ConsumerStatefulWidget {
  const Screen7({super.key});

  @override
  ConsumerState<Screen7> createState() => _Screen7State();
}

class _Screen7State extends ConsumerState<Screen7> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 7')),
      body: Row(
        children: [
          Expanded(child: ItemsList7(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard7()),
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
