import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen15 extends ConsumerStatefulWidget {
  const Screen15({super.key});

  @override
  ConsumerState<Screen15> createState() => _Screen15State();
}

class _Screen15State extends ConsumerState<Screen15> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 15')),
      body: Row(
        children: [
          Expanded(child: ItemsList15(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard15()),
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
