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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          ],
        ),
      ),
    );
  }
}