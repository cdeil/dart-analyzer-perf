import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen42 extends ConsumerStatefulWidget {
  const Screen42({super.key});

  @override
  ConsumerState<Screen42> createState() => _Screen42State();
}

class _Screen42State extends ConsumerState<Screen42> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 42')),
      body: Row(
        children: [
          Expanded(child: ItemsList42(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard42()),
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
