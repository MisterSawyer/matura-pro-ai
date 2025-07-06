import 'package:collection/collection.dart';

import '../models/category_question.dart';

class CategoryQuestionController {
  late final List<CategoryQuestion> questions;

  int get total => questions.length;

  Future<void> loadQuestions(List<dynamic> jsonObj) async {
    questions = [];
    for (final obj in jsonObj) {
      if (obj['type'] != 'category') {
        continue;
      }
      questions.add(CategoryQuestion.fromJson(obj as Map<String, dynamic>));
    }
  }

  void shuffle() {
    questions.shuffle();
  }

  int evaluate(List<Map<String, String>> answers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_isMatchEqual(answers[i], questions[i].correctMatches)) score++;
    }
    return score;
  }

  bool _isMatchEqual(Map<String, String> a, Map<String, String> b) {
    return const MapEquality().equals(a, b);
  }
}
