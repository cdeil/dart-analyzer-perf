import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen54 extends ConsumerStatefulWidget {
  const Screen54({super.key});

  @override
  ConsumerState<Screen54> createState() => _Screen54State();
}

class _Screen54State extends ConsumerState<Screen54> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 54')),
      body: Row(
        children: [
          Expanded(child: ItemsList54(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard54()),
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
