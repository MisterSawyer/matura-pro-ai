import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../controllers/questions/category_question_controller.dart';
import '../drag_and_drop/draggable_item.dart';
import '../drag_and_drop/drop_target.dart';

class CategoryQuestionContent extends StatefulWidget {
  final CategoryQuestionController controller;
  final ScrollController? scrollController;
  const CategoryQuestionContent({super.key, required this.controller, this.scrollController});

  @override
  State<CategoryQuestionContent> createState() =>
      _CategoryQuestionContentState();
}

class _CategoryQuestionContentState extends State<CategoryQuestionContent> {
  late final ScrollController _scrollController;
  Timer? _autoScrollTimer;
  Offset? _lastPointerOffset;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    if(widget.scrollController == null) _scrollController.dispose();
    super.dispose();
  }

  Widget _buildQuestionText() {
    return Text(
      widget.controller.question.question,
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDraggableItems() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: widget.controller.question.items
          .asMap()
          .entries
          .where((entry) => !widget.controller.containsIndex(entry.key))
          .map((entry) => DraggableItem<int>(
                label: entry.value,
                data: entry.key,
                onDragStarted: _startAutoScroll,
              ))
          .toList(),
    );
  }

  Widget _buildDropTargets() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: widget.controller.question.categories
          .asMap()
          .entries
          .map((categoryEntry) {
        final categoryIndex = categoryEntry.key;
        final categoryLabel = categoryEntry.value;

        final itemsInCategory = widget.controller.question.items
            .asMap()
            .keys
            .where((k) => widget.controller.inCategory(k, categoryIndex))
            .toList();

        final chips = itemsInCategory
            .map((itemIndex) => DraggableItem<int>(
                  data: itemIndex,
                  label: widget.controller.question.items[itemIndex],
                  onDragStarted: _startAutoScroll,
                ))
            .toList();

        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
            minHeight: 160,
          ),
          child: DropTarget<int>(
            label: categoryLabel,
            currentData: chips,
            onAccept: (details) {
              final itemIndex = details.data;
              setState(() {
                widget.controller.removeAnswer(itemIndex);
                widget.controller.addAnswer(itemIndex, categoryIndex);
              });
            },
          ),
        );
      }).toList(),
    );
  }

void _startAutoScroll() {
  _autoScrollTimer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
    if (_lastPointerOffset == null || !_scrollController.hasClients) return;

    final scrollPos = _scrollController.position;
    final y = _lastPointerOffset!.dy;

    const edgeThreshold = 80.0;
    const scrollAmount = 60.0;
    final screenHeight = MediaQuery.of(context).size.height;

    double? target;

    if (y < edgeThreshold &&
        scrollPos.pixels > scrollPos.minScrollExtent) {
      target = (scrollPos.pixels - scrollAmount)
          .clamp(scrollPos.minScrollExtent, scrollPos.maxScrollExtent);
    } else if (y > screenHeight - edgeThreshold &&
        scrollPos.pixels < scrollPos.maxScrollExtent) {
      target = (scrollPos.pixels + scrollAmount)
          .clamp(scrollPos.minScrollExtent, scrollPos.maxScrollExtent);
    }

    if (target != null && target != scrollPos.pixels) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  });
}

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    _lastPointerOffset = null;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        _lastPointerOffset = event.position;
      },
      onPointerUp: (_) => _stopAutoScroll(),
      onPointerCancel: (_) => _stopAutoScroll(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          _buildQuestionText(),
          const SizedBox(height: 32),
          _buildDraggableItems(),
          const SizedBox(height: 32),
          _buildDropTargets()
        ],
      ),
    );
  }
}
