import 'package:flutter/material.dart';

class DraggableItem extends StatelessWidget {
  final String label;

  const DraggableItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: label,
      feedback: Material(
        child: Chip(label: Text(label)),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: Chip(label: Text(label))),
      child: Chip(label: Text(label)),
    );
  }
}
