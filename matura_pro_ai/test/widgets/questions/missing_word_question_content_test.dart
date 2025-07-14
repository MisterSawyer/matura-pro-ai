import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/missing_word_question.dart';
import 'package:matura_pro_ai/controllers/questions/missing_word_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/missing_word_question_content.dart';

void main() {
  testWidgets('selecting dropdown option stores answer', (tester) async {
    final question = MissingWordQuestion.fromJson({
      'type': 'missing_word',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'choose \${0}',
      'items': [
        ['a', 'b']
      ],
      'correctMatches': {'0': 0}
    });
    final controller = MissingWordQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: MissingWordQuestionContent(controller: controller)),
    ));

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('a').last);
    await tester.pump();

    expect(controller.getAnswer(0), 0);
  });
}
