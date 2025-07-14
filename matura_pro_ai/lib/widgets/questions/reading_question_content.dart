import 'package:flutter/material.dart';

import '../../core/theme_defaults.dart';

import '../../controllers/questions/question_controller.dart';
import '../../controllers/questions/reading_question_controller.dart';

import 'question_widget_factory.dart';

class ReadingQuestionContent extends StatefulWidget {
  final ReadingQuestionController controller;

  const ReadingQuestionContent({
    super.key,
    required this.controller,
  });

  @override
  State<ReadingQuestionContent> createState() => _ReadingQuestionContentState();
}

class _ReadingQuestionContentState extends State<ReadingQuestionContent> {
  Widget _buildSubQuestion(int index, QuestionController subController) {
    final builder = questionWidgetMap[subController.runtimeType];
    if (builder != null) {
      return builder(subController);
    } else {
      throw UnsupportedError(
          "Unsupported controller: ${subController.runtimeType}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;
    final subControllers = widget.controller.subControllers;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Center(
                child: Text(
                  question.question,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(ThemeDefaults.padding),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colorScheme.secondaryContainer,
                  ),
                  child: Text(
                    question.text,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ...List.generate(
                question.questions.length,
                (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(ThemeDefaults.padding),
                      child: _buildSubQuestion(index, subControllers[index]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
