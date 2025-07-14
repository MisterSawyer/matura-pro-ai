import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/missing_word_question.dart';
import 'package:matura_pro_ai/controllers/questions/missing_word_question_controller.dart';

void main() {
  test('evaluate correct matches', () {
    final q = MissingWordQuestion.fromJson({
      'type': 'missing_word',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'fill \${0}',
      'items': [ ['a'] ],
      'correctMatches': {'0': 0}
    });
    final c = MissingWordQuestionController(q);
    c.addAnswer(0, 0);
    expect(c.evaluate(), 1);
  });
}
