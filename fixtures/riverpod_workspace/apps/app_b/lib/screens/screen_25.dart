import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen25 extends ConsumerStatefulWidget {
  const Screen25({super.key});

  @override
  ConsumerState<Screen25> createState() => _Screen25State();
}

class _Screen25State extends ConsumerState<Screen25> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 25')),
      body: Row(
        children: [
          Expanded(child: ItemsList25(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard25()),
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
