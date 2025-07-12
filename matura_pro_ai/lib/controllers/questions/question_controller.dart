import '../../models/questions/question.dart';
import '../../models/questions/question_type.dart';
import '../../models/tags.dart';
import '../../models/topics.dart';

abstract class QuestionController {

  final Question _questionBase;

  QuestionController(this._questionBase);

  QuestionType get type => _questionBase.type;

  Topics get topics => _questionBase.topics;

  Tags get tags => _questionBase.tags;

  bool isAnswered();

  void clear();

  double evaluate();
}
