import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/tags_and_topics_results.dart';
import 'package:matura_pro_ai/models/questions/question_topic.dart';

void main() {
  group('TagsAndTopicsResults', () {
    test('addTagResult averages values', () {
      final r = TagsAndTopicsResults();
      r.addTagResult('tag', 1);
      r.addTagResult('tag', 0);
      expect(r.tagsResults['tag']!.$1, closeTo(0.5, 0.001));
    });

    test('addTopicResult averages values', () {
      final r = TagsAndTopicsResults();
      r.addTopicResult(QuestionTopic.health, 1);
      r.addTopicResult(QuestionTopic.health, 0);
      expect(r.topicsResults[QuestionTopic.health]!.$1, closeTo(0.5, 0.001));
    });

    test('operator + merges results', () {
      final a = TagsAndTopicsResults();
      final b = TagsAndTopicsResults();
      a.addTagResult('tag', 1);
      b.addTagResult('tag', 0);
      final sum = a + b;
      expect(sum.tagsResults['tag']!.$1, closeTo(0.5, 0.001));
    });
  });
}
