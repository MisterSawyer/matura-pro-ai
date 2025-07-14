import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/missing_word_question.dart';

void main() {
  test('MissingWordQuestion.fromJson parses', () {
    final q = MissingWordQuestion.fromJson({
      'type': 'missing_word',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'text': 'fill \${0}',
      'items': [ ['a', 'b'] ],
      'correctMatches': {'0': 0}
    });
    expect(q.items.first.length, 2);
    expect(q.correctMatches[0], 0);
    expect(q.segments.length, 2);
  });
}
