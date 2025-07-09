import 'question_controller.dart';

import '../../models/questions/multiple_choice_question.dart';

class MultipleChoiceQuestionController extends QuestionController {
  final MultipleChoiceQuestion question;
  final Set<int> _answers = {};

  MultipleChoiceQuestionController(this.question) : super(question.type);

  void addAnswer(int index) {
    _answers.add(index);
  }

  void removeAnswer(int index) {
    _answers.remove(index);
  }

  bool isChecked(int index) => _answers.contains(index);

  @override
  bool isAnswered() => _answers.isNotEmpty;

  @override
  void clear() {
    _answers.clear();
  }

  @override
  double evaluate() {
    double score = 0.0;

    // add one for each correct answer
    for (int q = 0; q < question.correctIndexes.length; q++) {
      if (_answers.contains(question.correctIndexes[q])) {
        score += 1.0;
      }
    }
    // subtract one for each incorrect answer
    for (final ans in _answers) {
      if (question.correctIndexes.contains(ans) == false) {
        score -= 1.0;
      }
    }

    score = score.clamp(0, question.correctIndexes.length).toDouble();

    // divide by the number of correct answers to get the score between 0 and 1
    score /= question.correctIndexes.length;
    return score;
  }
}
