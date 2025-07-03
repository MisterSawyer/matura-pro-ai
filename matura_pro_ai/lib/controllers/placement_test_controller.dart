import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/placement_question.dart';

class PlacementTestController {
  late final List<PlacementQuestion> questions;

  Future<void> loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/placement_questions.json');
    final jsonList = json.decode(jsonString) as List<dynamic>;

    questions = jsonList
        .map((item) => PlacementQuestion.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  int evaluate(List<int> selectedAnswers) {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctIndex == selectedAnswers[i]) {
        score++;
      }
    }
    return score;
  }

  int get total => questions.length;
}