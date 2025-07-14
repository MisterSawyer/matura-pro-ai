import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/listening_question.dart';
import 'package:matura_pro_ai/controllers/questions/listening_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/listening_question_content.dart';

void main() {
  testWidgets('renders sub question', (tester) async {
    final question = ListeningQuestion.fromJson({
      'type': 'listening',
      'tags': [],
      'topics': [],
      'question': 'Listen',
      'audioPath': 'dummy.mp3',
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
    final controller = ListeningQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: ListeningQuestionContent(controller: controller)),
    ));

    expect(find.text('Listen'), findsOneWidget);
    expect(find.text('Odtwórz'), findsOneWidget);

    await tester.tap(find.text('a'));
    await tester.pump();

    final sub = controller.subControllers.first as dynamic;
    expect(sub.isChecked(0), isTrue);
  });
}
