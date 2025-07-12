import 'package:flutter/material.dart';
import '../../models/questions/question_topic.dart';
import '../../models/tags_and_topics_results.dart';

class TagsAndTopicsResultsView extends StatelessWidget {
  final TagsAndTopicsResults results;

  const TagsAndTopicsResultsView({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tagEntries = results.tagsResults.entries.toList()
      ..sort((a, b) => b.value.$1.compareTo(a.value.$1));

    final topicEntries = results.topicsResults.entries.toList()
      ..sort((a, b) => b.value.$1.compareTo(a.value.$1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...tagEntries.map((entry) => _buildProgressTagTile(
              context,
              label: entry.key,
              value: entry.value.$1,
            )),
        const SizedBox(height: 24),
        Text("Wyniki według tematów:", style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ...topicEntries.map((entry) => _buildProgressTopicTile(
              context,
              topic: entry.key,
              value: entry.value.$1,
            )),
      ],
    );
  }

  Widget _buildProgressTagTile(BuildContext context,
      {required String label, required double value}) {
    final percent = (value * 100).clamp(0, 100).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $percent%',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTopicTile(BuildContext context,
      {required QuestionTopic topic, required double value}) {
    final percent = (value * 100).clamp(0, 100).toStringAsFixed(1);
    final label = QuestionTopic.stringDesc(topic);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $percent%',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Row(children: [
            CircleAvatar(
              radius: 20,
              child: Icon(
                QuestionTopic.getIcon(topic),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
