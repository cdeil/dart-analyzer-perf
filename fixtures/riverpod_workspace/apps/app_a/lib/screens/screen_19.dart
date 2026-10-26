import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen19 extends ConsumerStatefulWidget {
  const Screen19({super.key});

  @override
  ConsumerState<Screen19> createState() => _Screen19State();
}

class _Screen19State extends ConsumerState<Screen19> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 19')),
      body: Row(
        children: [
          Expanded(child: ItemsList19(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard19()),
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
