import 'package:flutter/material.dart';
import 'package:matura_pro_ai/core/constants.dart';

class DropTarget extends StatelessWidget {
  final String label;
  final void Function(DragTargetDetails<String>) onAccept;
  final List<String> currentData;

  const DropTarget({
    super.key,
    required this.label,
    required this.onAccept,
    required this.currentData,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: onAccept,
      builder: (context, _, __) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(AppStyles.padding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (currentData.isEmpty)
                const Text(AppStrings.dropHere, style: TextStyle(fontStyle: FontStyle.italic)),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: currentData.map((item) {
                  return Draggable<String>(
                    data: item,
                    feedback: Material(
                      child: Chip(label: Text(item)),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.4,
                      child: Chip(label: Text(item)),
                    ),
                    child: Chip(label: Text(item)),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
