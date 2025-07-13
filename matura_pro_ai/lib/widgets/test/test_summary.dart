import 'package:flutter/material.dart';
import '../../models/test/test.dart';
import '../../models/questions/question_type.dart';

class TestSummaryPage extends StatelessWidget {
  final Test test;

  const TestSummaryPage({
    super.key,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: test.parts.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final part = test.parts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text("Questions: ${part.questions.length}"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: part.questions
                      .map((q) =>
                          Chip(label: Text(QuestionType.stringDesc(q.type))))
                      .toList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
