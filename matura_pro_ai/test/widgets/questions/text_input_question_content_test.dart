import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/text_input_question.dart';
import 'package:matura_pro_ai/controllers/questions/text_input_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/text_input_question_content.dart';

void main() {
  testWidgets('text field updates controller on unfocus', (tester) async {
    final question = TextInputQuestion.fromJson({
      'type': 'text_input',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'fill \${0}',
      'acceptedAnswers': [
        ['a']
      ]
    });
    final controller = TextInputQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: TextInputQuestionContent(controller: controller)),
    ));

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    // remove focus to trigger update
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    expect(controller.getAnswer(0), 'a');
  });
}
