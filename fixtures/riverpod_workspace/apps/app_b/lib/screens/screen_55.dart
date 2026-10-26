import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen55 extends ConsumerStatefulWidget {
  const Screen55({super.key});

  @override
  ConsumerState<Screen55> createState() => _Screen55State();
}

class _Screen55State extends ConsumerState<Screen55> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 55')),
      body: Row(
        children: [
          Expanded(child: ItemsList55(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard55()),
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
