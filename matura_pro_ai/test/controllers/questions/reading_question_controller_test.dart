import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/reading_question.dart';
import 'package:matura_pro_ai/controllers/questions/reading_question_controller.dart';

void main() {
  test('evaluate averages subcontrollers', () {
    final q = ReadingQuestion.fromJson({
      'type': 'reading',
      'tags': [],
      'topics': [],
      'question': 'Q',
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
    final c = ReadingQuestionController(q);
    final sub = c.subControllers.first as dynamic;
    sub.addAnswer(0);
    expect(c.evaluate(), 1);
  });
}
