import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen31 extends ConsumerStatefulWidget {
  const Screen31({super.key});

  @override
  ConsumerState<Screen31> createState() => _Screen31State();
}

class _Screen31State extends ConsumerState<Screen31> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 31')),
      body: Row(
        children: [
          Expanded(child: ItemsList31(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard31()),
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
