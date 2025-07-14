import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/category_question.dart';

void main() {
  test('CategoryQuestion.fromJson parses matches', () {
    final q = CategoryQuestion.fromJson({
      'type': 'category',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'items': ['a'],
      'categories': ['c'],
      'correctMatches': {'0': 0}
    });
    expect(q.correctMatches[0], 0);
  });
}
