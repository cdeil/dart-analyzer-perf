import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen24 extends ConsumerStatefulWidget {
  const Screen24({super.key});

  @override
  ConsumerState<Screen24> createState() => _Screen24State();
}

class _Screen24State extends ConsumerState<Screen24> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 24')),
      body: Row(
        children: [
          Expanded(child: ItemsList24(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard24()),
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
