import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/text_input_question.dart';

void main() {
  test('TextInputQuestion.fromJson normalizes answers', () {
    final q = TextInputQuestion.fromJson({
      'type': 'text_input',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'fill \${0}',
      'acceptedAnswers': [ ['A', 'a'] ]
    });
    expect(q.acceptedAnswers.first, contains('a'));
    expect(q.segments.length, 2);
  });
}
