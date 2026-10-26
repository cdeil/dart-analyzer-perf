import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/core.dart';

class Screen41 extends ConsumerStatefulWidget {
  const Screen41({super.key});

  @override
  ConsumerState<Screen41> createState() => _Screen41State();
}

class _Screen41State extends ConsumerState<Screen41> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('app_a screen 41')),
      body: Row(
        children: [
          Expanded(child: ItemsList41(onSelected: (id) => setState(() => _selected = id))),
          const Expanded(child: ItemCard41()),
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
