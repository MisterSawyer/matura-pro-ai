import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/test/test_part.dart';
import '../../models/questions/question.dart';
import '../../models/questions/question_type.dart';

import '../../models/questions/category_question.dart';
import '../../models/questions/multiple_choice_question.dart';
import '../../models/questions/reading_question.dart';
import '../../models/questions/text_input_question.dart';
import '../../models/questions/missing_word_question.dart';
import '../../models/questions/listening_question.dart';

import '../questions/question_controller.dart';
import '../questions/multiple_choice_question_controller.dart';
import '../questions/text_input_question_controller.dart';
import '../questions/category_question_controller.dart';
import '../questions/reading_question_controller.dart';
import '../questions/missing_word_question_controller.dart';
import '../questions/listening_question_controller.dart';

import 'test_part_state.dart';

class TestPartController extends StateNotifier<TestPartState> {
  final TestPart part;
  final List<QuestionController> _controllers = [];

  TestPartController({required this.part})
      : super(TestPartState(part: part)) {
    for (final question in part.questions) {
      _controllers.add(_createController(question));
    }
  }

  String get name => part.name;
  int get total => _controllers.length;
  int get currentIndex => state.currentQuestion;
  bool get isLastQuestion => currentIndex >= _controllers.length - 1;

  QuestionController? get currentQuestion =>
      (currentIndex < _controllers.length) ? _controllers[currentIndex] : null;

  List<QuestionController> get questions => List.unmodifiable(_controllers);

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    state = state.copyWith(currentQuestion: 0);
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      state = state.copyWith(currentQuestion: currentIndex + 1);
    }
  }

  double evaluate() {
    if (_controllers.isEmpty) return 0.0;
    return _controllers.map((c) => c.evaluate()).reduce((a, b) => a + b) /
        _controllers.length;
  }

  // Helper to create proper controller from model
  QuestionController _createController(Question question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestionController(
            question as MultipleChoiceQuestion);
      case QuestionType.textInput:
        return TextInputQuestionController(question as TextInputQuestion);
      case QuestionType.category:
        return CategoryQuestionController(question as CategoryQuestion);
      case QuestionType.reading:
        return ReadingQuestionController(question as ReadingQuestion);
      case QuestionType.missingWord:
        return MissingWordQuestionController(question as MissingWordQuestion);
      case QuestionType.listening:
        return ListeningQuestionController(question as ListeningQuestion);
    }
  }
}
