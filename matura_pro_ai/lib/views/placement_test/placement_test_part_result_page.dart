import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../controllers/test/test_part_controller.dart';
import '../../controllers/questions/question_controller.dart';
import '../../controllers/questions/multiple_choice_question_controller.dart';
import '../../controllers/questions/text_input_question_controller.dart';
import '../../controllers/questions/category_question_controller.dart';
import '../../controllers/questions/reading_question_controller.dart';
import '../../controllers/questions/missing_word_question_controller.dart';
import '../../controllers/questions/listening_question_controller.dart';

import '../../widgets/scrollable_layout.dart';
import '../../widgets/speedometer_gauge.dart';

class PlacementTestPartResultPage extends ConsumerWidget {
  final bool isLastPart;
  final TestPartController part;

  const PlacementTestPartResultPage({
    super.key,
    required this.part,
    this.isLastPart = false,
  });

  String _questionText(QuestionController controller) {
    if (controller is MultipleChoiceQuestionController) {
      return controller.question.question;
    } else if (controller is TextInputQuestionController) {
      return controller.question.question;
    } else if (controller is CategoryQuestionController) {
      return controller.question.question;
    } else if (controller is ReadingQuestionController) {
      return controller.question.question;
    } else if (controller is MissingWordQuestionController) {
      return controller.question.question;
    } else if (controller is ListeningQuestionController) {
      return controller.question.question;
    }
    return AppStrings.question;
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isLastPart) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, false); // exit test
          },
          child: const Text(AppStrings.wellDone),
        ),
      );
    }

    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true); // continue to next part
            },
            child: const Text(AppStrings.submit),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, false); // exit test
            },
            child: const Text(AppStrings.exitTest),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final score = part.evaluate() * 100.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              AppStrings.summary,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Center(
            child: Text(
              part.name,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Center(
            child: SpeedometerGauge(value: score),
          ),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: part.questions.length,
            itemBuilder: (context, index) {
              final controller = part.questions[index];
              final correct = controller.evaluate() == 1;
              final label = _questionText(controller);
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(label),
                leading: Text('${index + 1}.'),
                trailing: Icon(
                  correct ? Icons.check : Icons.close,
                  color: correct ? Colors.green : Colors.red,
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
