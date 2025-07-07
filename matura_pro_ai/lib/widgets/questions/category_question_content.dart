import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/category_question.dart';

import '../drag_and_drop/draggable_item.dart';
import '../drag_and_drop/drop_target.dart';

class CategoryQuestionContent extends StatefulWidget {
  final CategoryQuestion question;
  final int questionIndex;
  final int total;
  final ValueChanged<Map<String, String>> onAnswered; // item -> category

  const CategoryQuestionContent(
      {super.key,
      required this.question,
      required this.questionIndex,
      required this.total,
      required this.onAnswered});

  @override
  State<CategoryQuestionContent> createState() =>
      _CategoruQuestionContentState();
}

class _CategoruQuestionContentState extends State<CategoryQuestionContent> {

  final Map<String, String> _assigned = {}; // item -> category

  @override
  void dispose() {
    super.dispose();
  }

  void _submit() {
    if (_assigned.length < widget.question.items.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.categoriesIncomplete)),
      );
      return;
    }

    widget.onAnswered(_assigned);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text("Question ${widget.questionIndex + 1} of ${widget.total}",
                style: AppStyles.subHeader),
            const SizedBox(height: 16),
            Text(widget.question.question, style: AppStyles.header),
            const SizedBox(height: 32),
                  
            // Unassigned items
                  
            Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.question.items
                    .where((item) => !_assigned.containsKey(item))
                    .map((item) => DraggableItem(label: item))
                    .toList(),
              ),
            ),
                  
            const SizedBox(height: 32),
                  
            // Drop targets with wrapping
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: widget.question.categories.map((category) {
                  final itemsInCategory = _assigned.entries
                      .where((entry) => entry.value == category)
                      .map((entry) => entry.key)
                      .toList();
                  
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                      minHeight: 160,
                    ),
                    child: DropTarget(
                      label: category,
                      currentData: itemsInCategory,
                      onAccept: (DragTargetDetails<String> item) {
                        setState(() {
                          _assigned.removeWhere(
                              (key, value) => key == item.data);
                          _assigned[item.data] = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
                  
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text(AppStrings.submit),
              ),
            ),
            const SizedBox(height: 64),
          ],
        );
      },
    );
  }
}
