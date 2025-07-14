import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/listening_question.dart';

void main() {
  test('ListeningQuestion.fromJson parses subquestions', () {
    final q = ListeningQuestion.fromJson({
      'type': 'listening',
      'tags': [],
      'topics': [],
      'question': 'Q',
      'audioPath': 'a.mp3',
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
    expect(q.audioPath, 'a.mp3');
    expect(q.questions.length, 1);
  });
}
