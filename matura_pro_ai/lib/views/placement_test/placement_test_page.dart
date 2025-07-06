import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';

import '../../models/account.dart';
import '../../controllers/register_controller.dart';

import '../../controllers/multiple_choice_question_controller.dart';
import '../../widgets/multiple_choice_question_content.dart';

import '../../controllers/text_input_question_controller.dart';
import '../../widgets/text_input_question_content.dart';

import '../../widgets/three_column_layout.dart';

class PlacementTestPage extends StatefulWidget {
  final Account account;

  const PlacementTestPage({super.key, required this.account});

  @override
  State<PlacementTestPage> createState() => _PlacementTestPageState();
}

class _PlacementTestPageState extends State<PlacementTestPage> {
  final _multipleChoiceQuestionsController = MultipleChoiceQuestionController();
  final _textInputQuestionsController = TextInputQuestionController();

  List<List<int?>> _multipleChoiceAnswers = [];
  List<String?> _textInputAnswers = [];

  bool _cancelled = false;
  int _questionIndex = 0;
  int _multipleChoiceQuestionIndex = 0;
  int _textInputQuestionIndex = 0;

  int get _total =>
      _multipleChoiceQuestionsController.total +
      _textInputQuestionsController.total;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Load questions json
    final jsonString =
        await rootBundle.loadString('assets/placement_questions.json');
    final jsonObj = json.decode(jsonString) as List<dynamic>;

    // Load controllers
    await _multipleChoiceQuestionsController.loadQuestions(jsonObj);
    await _textInputQuestionsController.loadQuestions(jsonObj);

    setState(() {
      _multipleChoiceAnswers =
          List.filled(_multipleChoiceQuestionsController.questions.length, []);

      _textInputAnswers =
          List.filled(_textInputQuestionsController.questions.length, null);
    });

    // Automatically launch the first question after frame is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serveQuestion();
    });
  }

  void _submit() {
    if (_multipleChoiceAnswers.contains(null) ||
        _textInputAnswers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.enterAllAnswers)),
      );
      return;
    }

    var result = (_multipleChoiceQuestionsController
            .evaluate(_multipleChoiceAnswers.cast<List<int>>()) /
        _total);

    result += (_textInputQuestionsController
            .evaluate(_textInputAnswers.cast<String>()) /
        _total);

    setState(() {
      RegisterController.updateLastPlacementTestResult(
          widget.account.username, result * 100.0);
    });

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.placementTestResult,
      arguments: {
        'account': widget.account,
        'score': result * 100.0,
      },
    );
  }

  void _onCancel() {
    setState(() {
      _cancelled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Test cancelled before completion.")),
    );

    Navigator.pop(context); // Return to previous screen
  }

  Future<void> _serveMultipleChoiceQuestion() async {
    if (_multipleChoiceQuestionIndex >=
        _multipleChoiceQuestionsController.questions.length) {
      return;
    }

    final question = _multipleChoiceQuestionsController
        .questions[_multipleChoiceQuestionIndex];

    final result = await Navigator.push<List<int>>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text(AppStrings.placementTest)),
          body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: ThreeColumnLayout(
              left: const SizedBox(),
              center: MultipleChoiceQuestionContent(
                question: question,
                questionIndex: _questionIndex,
                total: _total,
                onAnswered: (value) => Navigator.pop(context, value),
              ),
              right: const SizedBox(),
            ),
          ),
        ),
      ),
    );

    if (mounted == false) {
      return;
    }
    if (result == null) {
      _onCancel();
      return;
    }

    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one answer.")),
      );
      _serveMultipleChoiceQuestion();
      return;
    }

    setState(() {
      _multipleChoiceAnswers[_multipleChoiceQuestionIndex] = result;
      _multipleChoiceQuestionIndex++;
      _questionIndex++;
    });
  }

  Future<void> _serveTextInputQuestion() async {
    if (_textInputQuestionIndex >=
        _textInputQuestionsController.questions.length) {
      return;
    }

    final question =
        _textInputQuestionsController.questions[_textInputQuestionIndex];

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text(AppStrings.placementTest)),
          body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: ThreeColumnLayout(
              left: const SizedBox(),
              center: TextInputQuestionContent(
                question: question,
                questionIndex: _questionIndex,
                total: _total,
                onAnswered: (value) {
                  Navigator.pop(context, value);
                },
              ),
              right: const SizedBox(),
            ),
          ),
        ),
      ),
    );

    if (mounted == false) {
      return;
    }
    if (result == null) {
      _onCancel();
      return;
    }

    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an answer.")),
      );
      _serveTextInputQuestion();
      return;
    }

    setState(() {
      _textInputAnswers[_textInputQuestionIndex] = result;
      _textInputQuestionIndex++;
      _questionIndex++;
    });
  }

  void _serveQuestion() async {
    if (_cancelled) {
      return;
    }
    final hasMultiple = _multipleChoiceQuestionIndex <
        _multipleChoiceQuestionsController.questions.length;
    final hasTextInput = _textInputQuestionIndex <
        _textInputQuestionsController.questions.length;

    if (!hasMultiple && !hasTextInput) {
      _submit();
      return;
    }

// Pick randomly if both are available
    if (hasMultiple && hasTextInput) {
      final random = Random().nextBool();
      if (random) {
        await _serveMultipleChoiceQuestion();
      } else {
        await _serveTextInputQuestion();
      }
    } else if (hasMultiple) {
      await _serveMultipleChoiceQuestion();
    } else {
      await _serveTextInputQuestion();
    }

    _serveQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.placementTest)),
        body: const Padding(
            padding: EdgeInsets.all(AppStyles.padding),
            child: Center(child: CircularProgressIndicator())));
  }
}
