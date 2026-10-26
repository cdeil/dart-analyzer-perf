import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen52 extends ConsumerStatefulWidget {
  const Screen52({super.key});

  @override
  ConsumerState<Screen52> createState() => _Screen52State();
}

class _Screen52State extends ConsumerState<Screen52> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 52')),
      body: Row(
        children: [
          Expanded(child: ItemsList52(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard52()),
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
