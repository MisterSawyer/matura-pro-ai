import 'question_controller.dart';

import 'package:collection/collection.dart';

import '../../models/questions/category_question.dart';

class CategoryQuestionController extends QuestionController {
  final CategoryQuestion question;
  final CategoryQestionAnswer _ans = CategoryQestionAnswer();

  CategoryQuestionController(this.question) : super(question);

  void addAnswer(int index, int category) => _ans.data[index] = category;

  void removeAnswer(int index) => _ans.data.remove(index);

  bool containsIndex(int index) => _ans.data.containsKey(index);

  bool inCategory(int index, int category) => _ans.data[index] == category;

  int? getAnswer(int index) => _ans.data[index];

  @override
  bool isAnswered() => true;

  @override
  void clear()
  {
    _ans.data.clear();
  }

  @override
  double evaluate() {
    if (const MapEquality().equals(_ans.data, question.correctMatches)) {
      return 1.0;
    }
    return 0.0;
  }
}
