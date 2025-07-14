import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/multiple_choice_question.dart';
import 'package:matura_pro_ai/controllers/questions/multiple_choice_question_controller.dart';

void main() {
  test('evaluate returns 1 for correct answer', () {
    final q = MultipleChoiceQuestion.fromJson({
      'type': 'multiple_choice',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'options': ['a','b'],
      'correctIndexes': [0]
    });
    final c = MultipleChoiceQuestionController(q);
    c.addAnswer(0);
    expect(c.evaluate(), 1);
  });

  test('evaluate penalizes wrong answers', () {
    final q = MultipleChoiceQuestion.fromJson({
      'type': 'multiple_choice',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'options': ['a','b'],
      'correctIndexes': [0]
    });
    final c = MultipleChoiceQuestionController(q);
    c.addAnswer(1);
    expect(c.evaluate(), 0);
  });
}
