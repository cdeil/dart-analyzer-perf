import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen20 extends ConsumerStatefulWidget {
  const Screen20({super.key});

  @override
  ConsumerState<Screen20> createState() => _Screen20State();
}

class _Screen20State extends ConsumerState<Screen20> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 20')),
      body: Row(
        children: [
          Expanded(child: ItemsList20(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard20()),
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
