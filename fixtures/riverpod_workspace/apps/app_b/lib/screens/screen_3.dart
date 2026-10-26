import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen3 extends ConsumerStatefulWidget {
  const Screen3({super.key});

  @override
  ConsumerState<Screen3> createState() => _Screen3State();
}

class _Screen3State extends ConsumerState<Screen3> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 3')),
      body: Row(
        children: [
          Expanded(child: ItemsList3(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard3()),
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
