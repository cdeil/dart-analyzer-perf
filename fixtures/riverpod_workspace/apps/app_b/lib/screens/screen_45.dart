import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen45 extends ConsumerStatefulWidget {
  const Screen45({super.key});

  @override
  ConsumerState<Screen45> createState() => _Screen45State();
}

class _Screen45State extends ConsumerState<Screen45> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 45')),
      body: Row(
        children: [
          Expanded(child: ItemsList45(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard45()),
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
