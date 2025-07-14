import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/question_topic.dart';

void main() {
  test('fromString returns enum value', () {
    expect(QuestionTopic.fromString('health'), QuestionTopic.health);
  });
}
