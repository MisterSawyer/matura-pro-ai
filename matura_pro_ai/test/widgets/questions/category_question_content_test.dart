import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/category_question.dart';
import 'package:matura_pro_ai/controllers/questions/category_question_controller.dart';
import 'package:matura_pro_ai/widgets/questions/category_question_content.dart';

void main() {
  testWidgets('dragging item into category stores answer', (tester) async {
    final question = CategoryQuestion.fromJson({
      'type': 'category',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'items': ['item'],
      'categories': ['cat'],
      'correctMatches': {'0': 0}
    });
    final controller = CategoryQuestionController(question);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: CategoryQuestionContent(controller: controller)),
    ));

    final itemFinder = find.text('item');
    final targetFinder = find.text('cat');

    final itemLoc = tester.getCenter(itemFinder);
    final targetLoc = tester.getCenter(targetFinder);

    final gesture = await tester.startGesture(itemLoc);
    await tester.pump();
    await gesture.moveTo(targetLoc);
    await gesture.up();
    await tester.pump();

    expect(controller.getAnswer(0), 0);
  });
}
