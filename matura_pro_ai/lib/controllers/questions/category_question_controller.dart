import 'question_controller.dart';

import 'package:collection/collection.dart';

import '../../models/questions/category_question.dart';

class CategoryQuestionController extends QuestionController {
  final CategoryQuestion question;
  final Map<int, int> _answers = {};

  CategoryQuestionController(this.question) : super(question.type);

  void addAnswer(int index, int category) => _answers[index] = category;

  void removeAnswer(int index) => _answers.remove(index);

  bool containsIndex(int index) => _answers.containsKey(index);

  bool inCategory(int index, int category) => _answers[index] == category;

  int? getAnswer(int index) => _answers[index];

  @override
  bool isAnswered() => _answers.length == question.items.length;

  @override
  void clear()
  {
    _answers.clear();
  }

  @override
  double evaluate() {
    if (const MapEquality().equals(_answers, question.correctMatches)) {
      return 1.0;
    }
    return 0.0;
  }
}
