import 'dart:math';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';

import '../../models/account.dart';

import '../../controllers/multiple_choice_question_controller.dart';
import '../../widgets/questions/multiple_choice_question_content.dart';

import '../../controllers/text_input_question_controller.dart';
import '../../widgets/questions/text_input_question_content.dart';

import '../../controllers/category_question_controller.dart';
import '../../widgets/questions/category_question_content.dart';

import '../../widgets/three_column_layout.dart';
import '../../widgets/no_scrollbar.dart';

class TestPage extends StatefulWidget {
  final String path;
  final String label;
  final Account account;

  final void Function(double) onSubmit;

  const TestPage(
      {super.key,
      required this.path,
      required this.label,
      required this.onSubmit,
      required this.account});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _multipleChoiceQuestionsController = MultipleChoiceQuestionController();
  final _textInputQuestionsController = TextInputQuestionController();
  final _categoryQuestionsController = CategoryQuestionController();

  final ScrollController _scrollController = ScrollController();

  List<List<int?>> _multipleChoiceAnswers = [];
  List<String?> _textInputAnswers = [];
  List<Map<String, String>> _categoryAnswers = [];

  bool _cancelled = false;

  int _questionIndex = 0;
  int _multipleChoiceQuestionIndex = 0;
  int _textInputQuestionIndex = 0;
  int _categoryQuestionIndex = 0;

  int get _total =>
      _multipleChoiceQuestionsController.total +
      _textInputQuestionsController.total +
      _categoryQuestionsController.total;

  @override
  void initState() {
    super.initState();
    _load(widget.path);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load(String path) async {
    // Load questions json
    final jsonString = await rootBundle.loadString(path);
    final jsonObj = json.decode(jsonString) as List<dynamic>;

    // Load controllers
    await _multipleChoiceQuestionsController.loadQuestions(jsonObj);
    await _textInputQuestionsController.loadQuestions(jsonObj);
    await _categoryQuestionsController.loadQuestions(jsonObj);

    _multipleChoiceQuestionsController.shuffle();
    _textInputQuestionsController.shuffle();
    _categoryQuestionsController.shuffle();

    setState(() {
      _multipleChoiceAnswers =
          List.filled(_multipleChoiceQuestionsController.questions.length, []);

      _textInputAnswers =
          List.filled(_textInputQuestionsController.questions.length, null);

      _categoryAnswers =
          List.filled(_categoryQuestionsController.questions.length, {});
    });

    // Automatically launch the first question after frame is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serveQuestion();
    });
  }

  void _submit() {
    if (_multipleChoiceAnswers.contains(null) ||
        _textInputAnswers.contains(null) ||
        _categoryAnswers.contains({})) {
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

    result += (_categoryQuestionsController
            .evaluate(_categoryAnswers.cast<Map<String, String>>()) /
        _total);

    setState(() {
      widget.onSubmit(result * 100.0);
    });

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.testResult,
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
          appBar: AppBar(title: Text(widget.label)),
          body: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Padding(
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
          appBar: AppBar(title: Text(widget.label)),
          body: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Padding(
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

  Future<void> _serveCategoryQuestion() async {
    if (_categoryQuestionIndex >=
        _categoryQuestionsController.questions.length) {
      return;
    }

    final question =
        _categoryQuestionsController.questions[_categoryQuestionIndex];

    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(widget.label)),
          body: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.padding),
                child: ThreeColumnLayout(
                  left: const SizedBox(),
                  center: CategoryQuestionContent(
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

    setState(() {
      _categoryAnswers[_categoryQuestionIndex] = result;
      _categoryQuestionIndex++;
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
    final hasCategory =
        _categoryQuestionIndex < _categoryQuestionsController.questions.length;

    // If there are no more questions, submit
    if (!hasMultiple && !hasTextInput && !hasCategory) {
      _submit();
      return;
    }

    // Pick randomly if available
    // _serveCategoryQuestion
    // _serveTextInputQuestion
    // _serveMultipleChoiceQuestion

    final available = <Future<void> Function()>[];
    if (hasMultiple) available.add(_serveMultipleChoiceQuestion);
    if (hasTextInput) available.add(_serveTextInputQuestion);
    if (hasCategory) available.add(_serveCategoryQuestion);

    final random = Random();
    final selected = available[random.nextInt(available.length)];
    await selected(); // Serve the randomly picked question

    _serveQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
          appBar: AppBar(title: Text(widget.label)),
          body: const Padding(
              padding: EdgeInsets.all(AppStyles.padding),
              child: Center(child: CircularProgressIndicator()))),
    );
  }
}
