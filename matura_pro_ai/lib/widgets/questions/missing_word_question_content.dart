import 'package:flutter/material.dart';

import '../../controllers/questions/missing_word_question_controller.dart';

class MissingWordQuestionContent extends StatefulWidget {
  final MissingWordQuestionController controller;

  const MissingWordQuestionContent({
    super.key,
    required this.controller,
  });

  @override
  State<MissingWordQuestionContent> createState() =>
      _MissingWordQuestionContentState();
}

class _MissingWordQuestionContentState
    extends State<MissingWordQuestionContent> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;
    final controller = widget.controller;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                question.question,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 64),
              Wrap(
                spacing: 8,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: question.segments.map((segment) {
                  if (!segment.isGap) {
                    return Baseline(
                      baseline: 20, //  match text baseline
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        segment.text!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  } else {
                    final gapIndex = segment.gapIndex!;
                    final options = question.items[gapIndex];

                    return Baseline(
                      baseline: 20, // Match the text baseline
                      baselineType: TextBaseline.alphabetic,
                      child: DropdownButton<int>(
                        value: controller.getAnswer(gapIndex),
                        hint: Text("...", style: theme.textTheme.bodyLarge),
                        style: theme.textTheme.bodyLarge,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              controller.addAnswer(gapIndex, value);
                            }
                          });
                        },
                        items: List.generate(options.length, (i) {
                          return DropdownMenuItem<int>(
                            value: i,
                            child: Text(options[i],
                                style: theme.textTheme.bodyLarge),
                          );
                        }),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
