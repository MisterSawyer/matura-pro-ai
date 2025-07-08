import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import 'draggable_item.dart';

class DropTarget<T extends Object> extends StatelessWidget {
  final String label;
  final void Function(DragTargetDetails<T>) onAccept;
  final List<DraggableItem> currentData;

  const DropTarget({
    super.key,
    required this.label,
    required this.onAccept,
    required this.currentData,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onAcceptWithDetails: onAccept,
      builder: (context, _, __) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(ThemeDefaults.padding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (currentData.isEmpty)
                const Text(AppStrings.dropHere, style: TextStyle(fontStyle: FontStyle.italic)),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: currentData.map((item) {
                  return item;
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
