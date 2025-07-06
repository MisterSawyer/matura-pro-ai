import 'dart:math';

import '../models/multiple_choice_question.dart';

class MultipleChoiceQuestionController {
  late final List<MultipleChoiceQuestion> questions;

  int get total => questions.length;

  Future<void> loadQuestions(List<dynamic> jsonObj) async {
    questions = [];
    for (final obj in jsonObj) {
      if (obj['type'] != 'multiple_choice') {
        continue;
      }
      questions
          .add(MultipleChoiceQuestion.fromJson(obj as Map<String, dynamic>));
    }
  }

  void shuffle() {
    questions.shuffle();
  }

  double evaluate(List<List<int>> answers) {
    double totalScore = 0;
    double questionScore = 0;
    for (int i = 0; i < questions.length; i++) {
      if (answers.length <= i) {
        break;
      }
      questionScore = 0;
      // add one for each correct answer
      for (int q = 0; q < questions[i].correctIndexes.length; q++) {
        if (answers[i].contains(questions[i].correctIndexes[q])) {
          questionScore += 1;
        }
      }
      // subtract one for each incorrect answer
      for (int a = 0; a < answers[i].length; a++) {
        if (questions[i].correctIndexes.contains(answers[i][a]) == false) {
          questionScore -= 1;
        }
      }
      // divide by the number of correct answers to get the score between 0 and 1
      totalScore +=
          max(0.0, questionScore / questions[i].correctIndexes.length);
    }
    return totalScore;
  }
}
