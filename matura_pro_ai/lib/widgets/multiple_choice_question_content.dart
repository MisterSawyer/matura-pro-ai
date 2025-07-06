import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../core/constants.dart';
import '../models/multiple_choice_question.dart';
import 'no_scrollbar.dart';

class MultipleChoiceQuestionContent extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final int questionIndex;
  final int total;
  final ValueChanged<List<int>> onAnswered;

  const MultipleChoiceQuestionContent({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.total,
    required this.onAnswered,
  });

  @override
  State<MultipleChoiceQuestionContent> createState() =>
      _MultipleChoiceQuestionContentState();
}

class _MultipleChoiceQuestionContentState
    extends State<MultipleChoiceQuestionContent> {
  final Set<int> _selectedIndexes = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _submit() {
    if (_selectedIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one answer.")),
      );
      return;
    }
    widget.onAnswered(_selectedIndexes.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: NoScrollbarBehavior(),
          child: SingleChildScrollView(
            controller: _scrollController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      "Question ${widget.questionIndex + 1} of ${widget.total}",
                      style: AppStyles.subHeader,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.question.question,
                      style: AppStyles.header,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 500;
                        final crossAxisCount = isNarrow ? 1 : 2;

                        return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: isNarrow ? 4.5 : 2.5,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            widget.question.options.length,
                            (index) {
                              final isSelected =
                                  _selectedIndexes.contains(index);
                              return OutlinedButton(
                                onPressed: () => _toggleSelection(index),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.surface,
                                  foregroundColor: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                  side: BorderSide(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.dividerColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  widget.question.options[index],
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Submit"),
                      ),
                    ),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
