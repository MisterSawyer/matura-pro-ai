import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/multiple_choice_question.dart';

void main() {
  test('MultipleChoiceQuestion.fromJson parses values', () {
    final q = MultipleChoiceQuestion.fromJson({
      'type': 'multiple_choice',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'options': ['a', 'b'],
      'correctIndexes': [0]
    });
    expect(q.options.length, 2);
    expect(q.correctIndexes.first, 0);
  });
}
