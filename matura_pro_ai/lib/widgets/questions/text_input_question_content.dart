import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../models/text_input_question.dart';

class TextInputQuestionContent extends StatefulWidget {
  final TextInputQuestion question;
  final int questionIndex;
  final int total;
  final ValueChanged<String> onAnswered;

  const TextInputQuestionContent({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.total,
    required this.onAnswered,
  });

  @override
  State<TextInputQuestionContent> createState() =>
      _TextInputQuestionContentState();
}

class _TextInputQuestionContentState extends State<TextInputQuestionContent> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final answer = _controller.text.trim().toLowerCase();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your answer.")),
      );
      return;
    }

    widget.onAnswered(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              "Question ${widget.questionIndex + 1} of ${widget.total}",
              style: AppStyles.subHeader,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.question.question,
              style: AppStyles.header,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Type your answer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("Submit"),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
