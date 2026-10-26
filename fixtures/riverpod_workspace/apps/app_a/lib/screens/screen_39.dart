import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen39 extends ConsumerStatefulWidget {
  const Screen39({super.key});

  @override
  ConsumerState<Screen39> createState() => _Screen39State();
}

class _Screen39State extends ConsumerState<Screen39> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 39')),
      body: Row(
        children: [
          Expanded(child: ItemsList39(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard39()),
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
