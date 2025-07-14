import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/multiple_choice_question.dart';
import 'package:matura_pro_ai/controllers/questions/multiple_choice_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/multiple_choice_question_content.dart';

void main() {
  testWidgets('tapping option toggles selection', (tester) async {
    final question = MultipleChoiceQuestion.fromJson({
      'type': 'multiple_choice',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'options': ['a', 'b'],
      'correctIndexes': [0]
    });
    final controller = MultipleChoiceQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: MultipleChoiceQuestionContent(controller: controller)),
    ));

    final optionFinder = find.text('a');
    expect(optionFinder, findsOneWidget);

    await tester.tap(optionFinder);
    await tester.pump();
    expect(controller.isChecked(0), isTrue);

    await tester.tap(optionFinder);
    await tester.pump();
    expect(controller.isChecked(0), isFalse);
  });
}
