import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/text_input_question.dart';
import 'package:matura_pro_ai/controllers/questions/text_input_question_controller.dart';

void main() {
  test('isAnswered and evaluate', () {
    final q = TextInputQuestion.fromJson({
      'type': 'text_input',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'fill \${0}',
      'acceptedAnswers': [ ['a'] ]
    });
    final c = TextInputQuestionController(q);
    expect(c.isAnswered(), isFalse);
    c.setAnswer(0, 'a');
    expect(c.isAnswered(), isTrue);
    expect(c.evaluate(), 1);
  });
}
