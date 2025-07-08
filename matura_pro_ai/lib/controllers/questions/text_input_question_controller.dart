import 'question_controller.dart';

import '../../models/questions/text_input_question.dart';

class TextInputQuestionController extends QuestionController {
  final TextInputQuestion question;

  // Stores answers per gap index
  final Map<int, String> _answers = {};

  TextInputQuestionController(this.question) : super(question.type);

  void setAnswer(int gapIndex, String answer) {
    _answers[gapIndex] = answer.trim().toLowerCase();
  }

  String? getAnswer(int gapIndex) => _answers[gapIndex];

  @override
  bool isAnswered() {
    return _answers.length == question.acceptedAnswers.length &&
        !_answers.values.any((value) => value.trim().isEmpty);
  }

  @override
  void clear() {
    _answers.clear();
  }

  @override
  double evaluate() {
    int total = question.acceptedAnswers.length;
    int correct = 0;

    for (int i = 0; i < total; i++) {
      final userAnswer = _answers[i]?.trim().toLowerCase();
      final accepted = question.acceptedAnswers[i];

      if (userAnswer != null && accepted.contains(userAnswer)) {
        correct++;
      }
    }

    return total == 0 ? 0.0 : correct / total;
  }
}
