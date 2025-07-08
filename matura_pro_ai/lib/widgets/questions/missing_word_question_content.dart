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
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: question.segments.map((segment) {
                  if (!segment.isGap) {
                    return Text(
                      segment.text!,
                      style: theme.textTheme.bodyLarge,
                    );
                  } else {
                    final gapIndex = segment.gapIndex!;
                    final options = question.items[gapIndex];

                    return DropdownButton<int>(
                      value: controller.getAnswer(gapIndex),
                      hint: const Text("..."),
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
                          style: theme.textTheme.bodyLarge,),
                        );
                      }),
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
