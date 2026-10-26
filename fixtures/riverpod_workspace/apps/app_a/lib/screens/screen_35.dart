import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen35 extends ConsumerStatefulWidget {
  const Screen35({super.key});

  @override
  ConsumerState<Screen35> createState() => _Screen35State();
}

class _Screen35State extends ConsumerState<Screen35> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 35')),
      body: Row(
        children: [
          Expanded(child: ItemsList35(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard35()),
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
