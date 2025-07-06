import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/text_input_question.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 64),
        Text("Question ${widget.questionIndex + 1} of ${widget.total}",
            style: AppStyles.subHeader),
        const SizedBox(height: 16),
        Text(widget.question.question, style: AppStyles.header),
        const SizedBox(height: 48),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Type your answer",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton(
            onPressed: _submit,
            child: const Text("Submit"),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
