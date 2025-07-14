import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/models/questions/question_topic.dart';
import 'package:matura_pro_ai/models/tags_and_topics_results.dart';
import 'package:matura_pro_ai/widgets/tags_and_topics_results_view.dart';

void main() {
  testWidgets('shows tag and topic progress', (tester) async {
    final results = TagsAndTopicsResults();
    results.addTagResult('tag1', 0.5);
    results.addTopicResult(QuestionTopic.home, 0.7);

    await tester.pumpWidget(MaterialApp(
      home: Material(child: TagsAndTopicsResultsView(results: results)),
    ));

    expect(find.textContaining('tag1'), findsOneWidget);
    expect(find.text('Dom'), findsOneWidget);
  });
}
