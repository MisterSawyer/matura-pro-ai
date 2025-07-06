import 'package:flutter/material.dart';

class DraggableItem extends StatelessWidget {
  final String label;

  const DraggableItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final chip = Chip(label: Text(label));

    return Draggable<String>(
      data: label,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: chip,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: chip,
      ),
      child: chip,
    );
  }
}
