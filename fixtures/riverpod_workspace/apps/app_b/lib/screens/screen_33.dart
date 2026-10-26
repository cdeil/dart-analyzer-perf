import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen33 extends ConsumerStatefulWidget {
  const Screen33({super.key});

  @override
  ConsumerState<Screen33> createState() => _Screen33State();
}

class _Screen33State extends ConsumerState<Screen33> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 33')),
      body: Row(
        children: [
          Expanded(child: ItemsList33(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard33()),
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
