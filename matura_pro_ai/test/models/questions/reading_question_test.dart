import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/reading_question.dart';

void main() {
  test('ReadingQuestion.fromJson parses subquestions', () {
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
    expect(q.questions.length, 1);
  });
}
