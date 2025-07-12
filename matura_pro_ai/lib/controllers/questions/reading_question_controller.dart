import 'question_controller.dart';

import '../../models/questions/multiple_choice_question.dart';
import '../../models/questions/text_input_question.dart';
import '../../models/questions/category_question.dart';
import '../../models/questions/missing_word_question.dart';

import '../../controllers/questions/multiple_choice_question_controller.dart';
import '../../controllers/questions/text_input_question_controller.dart';
import '../../controllers/questions/category_question_controller.dart';
import '../../controllers/questions/missing_word_question_controller.dart';

import '../../models/questions/question_type.dart';

import '../../models/questions/reading_question.dart';

class ReadingQuestionController extends QuestionController {
  final ReadingQuestion question;

  final List<QuestionController> _controllers = [];

  List<QuestionController> get subControllers => _controllers;

  ReadingQuestionController(this.question) : super(question) {
    for (final q in question.questions) {
      switch (q.type) {
        case QuestionType.multipleChoice:
          _controllers.add(
              MultipleChoiceQuestionController(q as MultipleChoiceQuestion));
          break;
        case QuestionType.textInput:
          _controllers.add(TextInputQuestionController(q as TextInputQuestion));
          break;
        case QuestionType.category:
          _controllers.add(CategoryQuestionController(q as CategoryQuestion));
          break;
        case QuestionType.missingWord:
          _controllers
              .add(MissingWordQuestionController(q as MissingWordQuestion));
          break;
        default:
          throw Exception('Invalid question type: ${q.type}');
      }
    }
  }

  @override
  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
  }

  @override
  bool isAnswered() {
    for (final controller in _controllers) {
      if (controller.isAnswered() == false) {
        return false;
      }
    }
    return true;
  }

  @override
  double evaluate() {
    double score = 0.0;
    for (final controller in _controllers) {
      score += controller.evaluate();
    }
    return score / _controllers.length;
  }
}
