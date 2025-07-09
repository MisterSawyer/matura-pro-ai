import 'package:flutter/material.dart';
import '../../controllers/questions/text_input_question_controller.dart';

class TextInputQuestionContent extends StatefulWidget {
  final TextInputQuestionController controller;

  const TextInputQuestionContent({
    super.key,
    required this.controller,
  });

  @override
  State<TextInputQuestionContent> createState() =>
      _TextInputQuestionContentState();
}

class _TextInputQuestionContentState extends State<TextInputQuestionContent> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();

    final gaps = widget.controller.question.acceptedAnswers.length;
    for (int i = 0; i < gaps; i++) {
      _controllers[i] = TextEditingController(text: '');
      _focusNodes[i] = FocusNode()
        ..addListener(() {
          if (!_focusNodes[i]!.hasFocus) {
            widget.controller.setAnswer(i, _controllers[i]!.text);
          }
        });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              question.question,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 12,
              children: question.segments.map((segment) {
                if (!segment.isGap) {
                  return Baseline(
                    baseline: 20, // Adjust if needed for your font
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      segment.text!,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }

                final index = segment.gapIndex!;
                return Baseline(
                  baseline: 20, // Same baseline as text
                  baselineType: TextBaseline.alphabetic,
                  child: SizedBox(
                    width: 160,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      style: theme
                          .textTheme.bodyLarge, // ensure text style matches
                      decoration: const InputDecoration(
                        labelText: 'write answer',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
