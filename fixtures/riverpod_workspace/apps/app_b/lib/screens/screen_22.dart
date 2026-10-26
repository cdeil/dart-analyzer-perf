import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen22 extends ConsumerStatefulWidget {
  const Screen22({super.key});

  @override
  ConsumerState<Screen22> createState() => _Screen22State();
}

class _Screen22State extends ConsumerState<Screen22> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_b screen 22')),
      body: Row(
        children: [
          Expanded(child: ItemsList22(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard22()),
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
