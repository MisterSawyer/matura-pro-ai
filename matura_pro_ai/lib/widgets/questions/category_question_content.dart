import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../controllers/questions/category_question_controller.dart';
import '../drag_and_drop/draggable_item.dart';
import '../drag_and_drop/drop_target.dart';

class CategoryQuestionContent extends StatefulWidget {
  final CategoryQuestionController controller;

  const CategoryQuestionContent({super.key, required this.controller});

  @override
  State<CategoryQuestionContent> createState() =>
      _CategoryQuestionContentState();
}

class _CategoryQuestionContentState extends State<CategoryQuestionContent> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollContainerKey = GlobalKey();
  int _scrollDirection = 0;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _startScrollMonitor();
  }

  void _startScrollMonitor() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_scrollDirection == 0 || !_scrollController.hasClients) return;

      final current = _scrollController.offset;
      const delta = 20;

      final newOffset = (_scrollDirection == -1)
          ? (current - delta)
          : (current + delta);

      if (newOffset != current) {
        _scrollController.jumpTo(newOffset);
      }
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {

    final screenHeight = MediaQuery.of(context).size.height;

    final box = _scrollContainerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    final localOffset = box.globalToLocal(details.globalPosition);

    const edgeThreshold = 80.0;
    if (localOffset.dy < edgeThreshold) {
      _scrollDirection = -1;
    } else if (localOffset.dy > screenHeight - edgeThreshold) {
      _scrollDirection = 1;
    } else {
      _scrollDirection = 0;
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;
    final controller = widget.controller;

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        key: _scrollContainerKey,
        controller: _scrollController,
        dragStartBehavior: DragStartBehavior.down,
        padding: const EdgeInsets.all(16),
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height + 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                question.question,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: question.items
                    .asMap()
                    .entries
                    .where((entry) => !controller.containsIndex(entry.key))
                    .map((entry) => DraggableItem<int>(
                      label: entry.value,
                          data: entry.key,
                          onDragUpdate: _handleDragUpdate
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: question.categories
                    .asMap()
                    .entries
                    .map((categoryEntry) {
                  final categoryIndex = categoryEntry.key;
                  final categoryLabel = categoryEntry.value;

                  final itemsInCategory = question.items
                      .asMap()
                      .keys
                      .where((k) => controller.inCategory(k, categoryIndex))
                      .toList();

                  final chips = itemsInCategory
                      .map((itemIndex) => DraggableItem<int>(
                            data: itemIndex,
                            label: question.items[itemIndex],
                            onDragUpdate: _handleDragUpdate,
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
                          controller.removeAnswer(itemIndex);
                          controller.addAnswer(itemIndex, categoryIndex);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}