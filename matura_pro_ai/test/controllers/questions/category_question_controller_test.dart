import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/category_question.dart';
import 'package:matura_pro_ai/controllers/questions/category_question_controller.dart';

void main() {
  test('evaluate full match', () {
    final q = CategoryQuestion.fromJson({
      'type': 'category',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'items': ['a'],
      'categories': ['c'],
      'correctMatches': {'0': 0}
    });
    final c = CategoryQuestionController(q);
    c.addAnswer(0, 0);
    expect(c.evaluate(), 1);
    c.removeAnswer(0);
    expect(c.evaluate(), 0);
  });
}
