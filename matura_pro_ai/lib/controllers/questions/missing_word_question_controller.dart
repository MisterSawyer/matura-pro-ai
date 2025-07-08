import 'question_controller.dart';

import '../../models/questions/missing_word_question.dart';

class MissingWordQuestionController extends QuestionController {
  final MissingWordQuestion question;
  final Map<int, int> _answers = {};

  MissingWordQuestionController(this.question) : super(question.type);

  void addAnswer(int index, int option) => _answers[index] = option;

  void removeAnswer(int index) => _answers.remove(index);

  int? getAnswer(int index) => _answers[index];

  @override
  bool isAnswered() => question.correctMatches.keys
      .where((key) => !_answers.containsKey(key))
      .toList()
      .isEmpty;

  @override
  void clear() {
    _answers.clear();
  }

  @override
  double evaluate() {
    int total = question.correctMatches.length;
    int correct = 0;

    for (final entry in question.correctMatches.entries) {
      final blankIndex = entry.key;
      final correctOption = entry.value;
      final userOption = _answers[blankIndex];

      if (userOption != null && userOption == correctOption) {
        correct++;
      }
    }

    return total == 0 ? 0.0 : correct.toDouble() / total.toDouble();
  }
}
