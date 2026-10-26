import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen38 extends ConsumerStatefulWidget {
  const Screen38({super.key});

  @override
  ConsumerState<Screen38> createState() => _Screen38State();
}

class _Screen38State extends ConsumerState<Screen38> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 38')),
      body: Row(
        children: [
          Expanded(child: ItemsList38(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard38()),
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
