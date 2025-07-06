import '../models/text_input_question.dart';

class TextInputQuestionController {
  late final List<TextInputQuestion> questions;

  int get total => questions.length;

  Future<void> loadQuestions(List<dynamic> jsonObj) async {
    questions = [];
    for (final obj in jsonObj) {
      if (obj['type'] != 'text_input') {
        continue;
      }
      questions.add(TextInputQuestion.fromJson(obj as Map<String, dynamic>));
    }
  }

  void shuffle() {
    questions.shuffle();
  }

  double evaluate(List<String> answer) {
    double totalScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answer.length <= i) break;

      final normalizedAnswer = answer[i].trim().toLowerCase();

      if (questions[i].acceptedAnswers.contains(normalizedAnswer)) {
        totalScore += 1;
      }
    }
    return totalScore;
  }
}
