import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen14 extends ConsumerStatefulWidget {
  const Screen14({super.key});

  @override
  ConsumerState<Screen14> createState() => _Screen14State();
}

class _Screen14State extends ConsumerState<Screen14> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 14')),
      body: Row(
        children: [
          Expanded(child: ItemsList14(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard14()),
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
