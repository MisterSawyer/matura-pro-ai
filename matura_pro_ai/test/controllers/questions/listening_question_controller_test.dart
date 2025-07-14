import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/listening_question.dart';
import 'package:matura_pro_ai/controllers/questions/listening_question_controller.dart';

void main() {
  test('evaluate averages subcontrollers', () {
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
    final c = ListeningQuestionController(q);
    final sub = c.subControllers.first as dynamic;
    sub.addAnswer(0);
    expect(c.evaluate(), 1);
  });
}
