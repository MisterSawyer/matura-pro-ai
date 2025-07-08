import '../../models/questions/question_type.dart';

abstract class QuestionController {

  QuestionType type;

  QuestionController(this.type);

  bool isAnswered();

  void clear();

  double evaluate();
}
