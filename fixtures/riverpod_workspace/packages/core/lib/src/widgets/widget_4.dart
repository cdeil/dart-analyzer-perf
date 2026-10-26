import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:core/src/providers/provider_4.dart';

/// Widget 4: lists the items of provider 4.
class ItemsList4 extends ConsumerWidget {
  const ItemsList4({super.key, this.onSelected});

  final ValueChanged<String?>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(items4Provider);
    final selected = ref.watch(selection4Provider);
    final format = NumberFormat.decimalPattern();
    return items.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (values) => ListView.builder(
        itemCount: values.length,
        itemBuilder: (context, index) {
          final item = values[index];
          return ListTile(
            key: ValueKey(item.field1),
            selected: item.field1 == selected,
            title: Text(item.field1),
            subtitle: Text(format.format(item.field2)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  ref.read(items4Provider.notifier).remove(item.field1),
            ),
            onTap: () {
              ref.read(selection4Provider.notifier).select(item.field1);
              onSelected?.call(item.field1);
            },
          );
        },
      ),
    );
  }
}

/// Detail card 4: shows the selected item of provider 4.
class ItemCard4 extends ConsumerWidget {
  const ItemCard4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(selectedItem4Provider);
    if (item == null) {
      return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Nothing selected')));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.field1, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('${item.field2} / ${item.field3}'),
            TextButton(
              onPressed: () => ref.read(selection4Provider.notifier).clear(),
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}
