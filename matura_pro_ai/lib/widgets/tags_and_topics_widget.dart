import 'package:flutter/material.dart';
import 'package:matura_pro_ai/core/theme_defaults.dart';
import '../models/questions/question_topic.dart';
import '../models/tags.dart';
import '../models/topics.dart';

class TagsAndTopicsWidget extends StatelessWidget {
  final Tags tags;
  final Topics topics;

  const TagsAndTopicsWidget({
    super.key,
    required this.tags,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tags.isNotEmpty) ...[
          Row(
          children:[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.shade50,
                    ))
                .toList(),
          ),
          ])
        ],
        const SizedBox(height: ThemeDefaults.padding),
        if (topics.isNotEmpty) ...[
          Row(
            children:[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: topics
                .map((topic) => Chip(
                      label: Text(QuestionTopic.stringDesc(topic)),
                      backgroundColor: Colors.green.shade50,
                    ))
                .toList(),
          ),
        ]
          )
        ],
      ],
    );
  }
}
