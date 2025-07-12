import 'package:flutter/material.dart';

class DraggableItem<T extends Object> extends StatelessWidget {
  final String label;
  final T data;
  final VoidCallback? onDragStarted;
  final void Function(DragUpdateDetails)? onDragUpdate;
  final void Function(DraggableDetails)? onDragEnd;

  const DraggableItem({super.key, required this.label, required this.data, this.onDragStarted, this.onDragUpdate, this.onDragEnd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final widgetBox = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            label,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: theme.textTheme.bodySmall,
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
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      onDragUpdate : onDragUpdate,
      child: widgetBox,
    );
  }
}

