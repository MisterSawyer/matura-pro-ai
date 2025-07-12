import 'package:flutter/material.dart';

import '../../controllers/questions/multiple_choice_question_controller.dart';

class MultipleChoiceQuestionContent extends StatefulWidget {
  final MultipleChoiceQuestionController controller;

  const MultipleChoiceQuestionContent({
    super.key,
    required this.controller,
  });

  @override
  State<MultipleChoiceQuestionContent> createState() =>
      _MultipleChoiceQuestionContentState();
}

class _MultipleChoiceQuestionContentState
    extends State<MultipleChoiceQuestionContent> {
  @override
  void dispose() {
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (widget.controller.isChecked(index)) {
        widget.controller.removeAnswer(index);
      } else {
        widget.controller.addAnswer(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                question.question,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(
                      question.options.length,
                      (index) {
                        final isSelected = widget.controller.isChecked(index);
                        return InkWell(
                          onTap: () => _toggleSelection(index),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Text(question.options[index],
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
