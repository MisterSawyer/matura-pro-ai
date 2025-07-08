import 'package:flutter/material.dart';

class DraggableItem<T extends Object> extends StatelessWidget {
  final String label;
  final T data;

  const DraggableItem({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    final widgetBox = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            label,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );

    return Draggable<T>(
      data: data,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: widgetBox,
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: widgetBox),
      child: widgetBox,
    );
  }
}

