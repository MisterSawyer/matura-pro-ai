import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/topics.dart';
import 'package:matura_pro_ai/models/questions/question_topic.dart';

void main() {
  group('Topics', () {
    test('fromJson converts strings to enums', () {
      final topics = Topics.fromJson(['human', 'home']);
      expect(topics.first, QuestionTopic.human);
    });

    test('toJson returns string list', () {
      final topics = Topics([QuestionTopic.food]);
      expect(topics.toJson(), ['QuestionTopic.food']);
    });
  });
}
