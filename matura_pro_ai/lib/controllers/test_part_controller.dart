import '../../models/questions/question_type.dart';

import '../../models/test_part.dart';

import '../models/questions/category_question.dart';
import '../models/questions/multiple_choice_question.dart';
import '../models/questions/reading_question.dart';
import '../models/questions/text_input_question.dart';
import '../models/questions/missing_word_question.dart';
import '../models/questions/listening_question.dart';

import '../controllers/questions/question_controller.dart';
import '../controllers/questions/multiple_choice_question_controller.dart';
import '../controllers/questions/text_input_question_controller.dart';
import '../controllers/questions/category_question_controller.dart';
import '../controllers/questions/reading_question_controller.dart';
import '../controllers/questions/missing_word_question_controller.dart';
import '../controllers/questions/listening_question_controller.dart';

class TestPartController {
  int _currentQuestion = 0;

  final TestPart part;

  final List<QuestionType> _order = [];

  final List<MultipleChoiceQuestionController>
      _multipleChoiceQuestionControllers = [];
  final List<TextInputQuestionController> _textInputQuestionControllers = [];
  final List<CategoryQuestionController> _categoryQuestionControllers = [];
  final List<ReadingQuestionController> _readingQuestionControllers = [];
  final List<MissingWordQuestionController> _missingWordQuestionControllers =
      [];
  final List<ListeningQuestionController> _listeningQuestionControllers = [];
  final Map<QuestionType, int> _questionCounters = {};

  List<QuestionController> get questions {
    final all = <QuestionController>[];

    // Maintain question order using _order and counters
    final typeIndex = {
      QuestionType.multipleChoice: 0,
      QuestionType.textInput: 0,
      QuestionType.category: 0,
      QuestionType.reading: 0,
      QuestionType.missingWord: 0,
      QuestionType.listening: 0,
    };

    for (final type in _order) {
      final index = typeIndex[type]!;
      all.add(getControllers(type)[index]);
      typeIndex[type] = index + 1;
    }

    return all;
  }

  TestPartController({required this.part}) {
    // set up counters
    clear();

    for (final question in part.questions) {
      switch (question.type) {
        case QuestionType.multipleChoice:
          _order.add(QuestionType.multipleChoice);
          _multipleChoiceQuestionControllers.add(
              MultipleChoiceQuestionController(
                  question as MultipleChoiceQuestion));
          break;
        case QuestionType.textInput:
          _order.add(QuestionType.textInput);
          _textInputQuestionControllers
              .add(TextInputQuestionController(question as TextInputQuestion));
          break;
        case QuestionType.category:
          _order.add(QuestionType.category);
          _categoryQuestionControllers
              .add(CategoryQuestionController(question as CategoryQuestion));
          break;
        case QuestionType.reading:
          _order.add(QuestionType.reading);
          _readingQuestionControllers
              .add(ReadingQuestionController(question as ReadingQuestion));
          break;
        case QuestionType.missingWord:
          _order.add(QuestionType.missingWord);
          _missingWordQuestionControllers.add(
              MissingWordQuestionController(question as MissingWordQuestion));
          break;
        case QuestionType.listening:
          _order.add(QuestionType.listening);
          _listeningQuestionControllers
              .add(ListeningQuestionController(question as ListeningQuestion));
          break;
      }
    }
    assert(_order.length == part.questions.length);
  }

  String get name => part.name;
  int get total => part.questions.length;
  bool get isLastQuestion => _currentQuestion >= _order.length - 1;

  void clear() {
    _currentQuestion = 0;
    _questionCounters[QuestionType.multipleChoice] = 0;
    _questionCounters[QuestionType.textInput] = 0;
    _questionCounters[QuestionType.category] = 0;
    _questionCounters[QuestionType.reading] = 0;
    _questionCounters[QuestionType.missingWord] = 0;
    _questionCounters[QuestionType.listening] = 0;

    for (final controller in _multipleChoiceQuestionControllers) {
      controller.clear();
    }
    for (final controller in _textInputQuestionControllers) {
      controller.clear();
    }
    for (final controller in _categoryQuestionControllers) {
      controller.clear();
    }
    for (final controller in _readingQuestionControllers) {
      controller.clear();
    }
    for (final controller in _missingWordQuestionControllers) {
      controller.clear();
    }
  }

  List<QuestionController> getControllers(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return _multipleChoiceQuestionControllers;
      case QuestionType.textInput:
        return _textInputQuestionControllers;
      case QuestionType.category:
        return _categoryQuestionControllers;
      case QuestionType.reading:
        return _readingQuestionControllers;
      case QuestionType.missingWord:
        return _missingWordQuestionControllers;
      case QuestionType.listening:
        return _listeningQuestionControllers;
    }
  }

  QuestionController? currentQuestionController() {
    if (_currentQuestion >= _order.length) return null;
    switch (_order[_currentQuestion]) {
      case QuestionType.multipleChoice:
        if (_questionCounters[QuestionType.multipleChoice] == null) return null;
        if (_questionCounters[QuestionType.multipleChoice]! >=
            _multipleChoiceQuestionControllers.length) return null;
        return _multipleChoiceQuestionControllers[
            _questionCounters[QuestionType.multipleChoice]!];

      case QuestionType.textInput:
        if (_questionCounters[QuestionType.textInput] == null) return null;
        if (_questionCounters[QuestionType.textInput]! >=
            _textInputQuestionControllers.length) return null;
        return _textInputQuestionControllers[
            _questionCounters[QuestionType.textInput]!];

      case QuestionType.category:
        if (_questionCounters[QuestionType.category] == null) return null;
        if (_questionCounters[QuestionType.category]! >=
            _categoryQuestionControllers.length) return null;
        return _categoryQuestionControllers[
            _questionCounters[QuestionType.category]!];

      case QuestionType.reading:
        if (_questionCounters[QuestionType.reading] == null) return null;
        if (_questionCounters[QuestionType.reading]! >=
            _readingQuestionControllers.length) return null;
        return _readingQuestionControllers[
            _questionCounters[QuestionType.reading]!];

      case QuestionType.missingWord:
        if (_questionCounters[QuestionType.missingWord] == null) return null;
        if (_questionCounters[QuestionType.missingWord]! >=
            _missingWordQuestionControllers.length) return null;
        return _missingWordQuestionControllers[
            _questionCounters[QuestionType.missingWord]!];

      case QuestionType.listening:
        if (_questionCounters[QuestionType.listening] == null) return null;
        if (_questionCounters[QuestionType.listening]! >=
            _listeningQuestionControllers.length) return null;
        return _listeningQuestionControllers[
            _questionCounters[QuestionType.listening]!];
      default:
        return null;
    }
  }

  void nextQuestion() {
    if (isLastQuestion) {
      return;
    }

    // update counter of current question
    _questionCounters[_order[_currentQuestion]] =
        _questionCounters[_order[_currentQuestion]]! + 1;

    _currentQuestion++;
  }

  double evaluate() {
    double score = 0.0;
    for (final controller in _multipleChoiceQuestionControllers) {
      score += controller.evaluate();
    }

    for (final controller in _textInputQuestionControllers) {
      score += controller.evaluate();
    }

    for (final controller in _categoryQuestionControllers) {
      score += controller.evaluate();
    }

    for (final controller in _readingQuestionControllers) {
      score += controller.evaluate();
    }

    for (final controller in _missingWordQuestionControllers) {
      score += controller.evaluate();
    }

    for (final controller in _listeningQuestionControllers) {
      score += controller.evaluate();
    }

    return score / _order.length;
  }
}
