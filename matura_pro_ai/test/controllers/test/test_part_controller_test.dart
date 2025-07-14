import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/test/test_part.dart';
import 'package:matura_pro_ai/controllers/test/test_part_controller.dart';

void main() {
  test('nextQuestion advances order', () {
      final part = TestPart.fromJson(const {
      'name': 'p',
        'questions': [
          {
            'type': 'multiple_choice',
            'tags': [],
            'topics': [],
            'question': 'Q',
            'options': ['a'],
            'correctIndexes': [0]
          },
          {
            'type': 'multiple_choice',
            'tags': [],
            'topics': [],
            'question': 'Q2',
            'options': ['a'],
            'correctIndexes': [0]
          }
        ]
    });
    final c = TestPartController(part: part);
    expect(c.isLastQuestion, isFalse);
    c.nextQuestion();
    expect(c.currentQuestionController(), isNotNull);
  });
}
