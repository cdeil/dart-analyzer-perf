import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen51 extends ConsumerStatefulWidget {
  const Screen51({super.key});

  @override
  ConsumerState<Screen51> createState() => _Screen51State();
}

class _Screen51State extends ConsumerState<Screen51> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 51')),
      body: Row(
        children: [
          Expanded(child: ItemsList51(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard51()),
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
