import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen5 extends ConsumerStatefulWidget {
  const Screen5({super.key});

  @override
  ConsumerState<Screen5> createState() => _Screen5State();
}

class _Screen5State extends ConsumerState<Screen5> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 5')),
      body: Row(
        children: [
          Expanded(child: ItemsList5(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard5()),
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
