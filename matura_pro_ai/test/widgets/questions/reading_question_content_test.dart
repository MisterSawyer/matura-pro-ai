import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/reading_question.dart';
import 'package:matura_pro_ai/controllers/questions/reading_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/reading_question_content.dart';

void main() {
  testWidgets('sub question is displayed and can be answered', (tester) async {
    final question = ReadingQuestion.fromJson({
      'type': 'reading',
      'tags': [],
      'topics': [],
      'question': 'Read',
      'text': 'T',
      'questions': [
        {
          'type': 'multiple_choice',
          'tags': [],
          'topics': [],
          'question': 'sub',
          'options': ['a'],
          'correctIndexes': [0]
        }
      ]
    });
    final controller = ReadingQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: ReadingQuestionContent(controller: controller)),
    ));

    expect(find.text('Read'), findsOneWidget);
    expect(find.text('sub'), findsOneWidget);

    await tester.tap(find.text('a'));
    await tester.pump();

    final sub = controller.subControllers.first as dynamic;
    expect(sub.isChecked(0), isTrue);
  });
}
