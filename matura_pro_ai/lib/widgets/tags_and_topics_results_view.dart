import 'package:flutter/material.dart';
import 'package:matura_pro_ai/core/theme_defaults.dart';
import '../../models/questions/question_topic.dart';
import '../../models/tags_and_topics_results.dart';

class TagsAndTopicsResultsView extends StatelessWidget {
  final TagsAndTopicsResults results;

  const TagsAndTopicsResultsView({super.key, required this.results});

  @override
  Widget build(BuildContext context) {

    final tagEntries = results.tagsResults.entries.toList()
      ..sort((a, b) => b.value.$1.compareTo(a.value.$1));

    final topicEntries = results.topicsResults.entries.toList()
      ..sort((a, b) => b.value.$1.compareTo(a.value.$1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ...tagEntries.map((entry) => _buildProgressTagTile(
              context,
              label: entry.key,
              value: entry.value.$1,
            )),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topicEntries.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final entry = topicEntries[index];
            return _buildTopicPieCard(context, entry.key, entry.value.$1);
          },
        ),
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

  Widget _buildTopicPieCard(
      BuildContext context, QuestionTopic topic, double value) {
    final theme = Theme.of(context);
    final percent = (value * 100).clamp(0, 100);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              QuestionTopic.stringDesc(topic),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: ThemeDefaults.padding),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Icon(QuestionTopic.getIcon(topic)),
                ),
                const SizedBox(height: ThemeDefaults.padding),
                SizedBox(
                  height: 64,
                  width: 64,
                  child: CircularProgressIndicator(
                    value: value.clamp(0.0, 1.0),
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade300,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeDefaults.padding),
            Text('${percent.toStringAsFixed(0)}%',
                style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
