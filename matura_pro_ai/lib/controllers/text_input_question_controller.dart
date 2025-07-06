import '../models/text_input_question.dart';

class TextInputQuestionController {
  late final List<TextInputQuestion> questions;

  Future<void> loadQuestions(List<dynamic> jsonObj) async {
    questions = [];
    for (final obj in jsonObj) {
      if (obj['type'] != 'text_input') {
        continue;
      }
      questions.add(TextInputQuestion.fromJson(obj as Map<String, dynamic>));
    }
  }

  double evaluate(List<String> answer) {
    double totalScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answer.length <= i) {
        break;
      }
      if (questions[i].acceptedAnswers.contains(answer[i])) {
        totalScore += 1;
      }
    }
    return totalScore;
  }

  int get total => questions.length;
}
