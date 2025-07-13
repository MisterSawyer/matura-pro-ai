import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../controllers/test/test_controller.dart';
import '../../controllers/test/test_part_controller.dart';
import '../../controllers/questions/question_controller.dart';

import '../../controllers/questions/category_question_controller.dart';
import '../../controllers/questions/multiple_choice_question_controller.dart';
import '../../controllers/questions/text_input_question_controller.dart';
import '../../controllers/questions/reading_question_controller.dart';
import '../../controllers/questions/missing_word_question_controller.dart';
import '../../controllers/questions/listening_question_controller.dart';

import '../no_scrollbar.dart';

import '../questions/multiple_choice_question_content.dart';
import '../questions/text_input_question_content.dart';
import '../questions/category_question_content.dart';
import '../questions/reading_question_content.dart';
import '../questions/missing_word_question_content.dart';
import '../questions/listening_question_content.dart';

class TestPage extends StatefulWidget {
  final TestController testController;
  final String label;

  final Future<void> Function() onTestEnded;
  final Future<bool> Function(TestPartController) onPartFinished;

  const TestPage({
    super.key,
    required this.testController,
    required this.label,
    required this.onTestEnded,
    required this.onPartFinished,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final ScrollController _scrollController = ScrollController();

  QuestionController? _currentQuestionController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serveQuestion();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _serveQuestion() async {
    final part = widget.testController.currentPart;
    final controller = part.currentQuestionController();

    if (controller == null) {
      widget.testController.nextPart();
      _serveQuestion();
      return;
    }

    setState(() {
      _currentQuestionController = controller;
    });

    // Ensure scroll reset happens after the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  Widget _buildQuestionWidget() {
    if (_currentQuestionController == null) return Container();

    if (_currentQuestionController is MultipleChoiceQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as MultipleChoiceQuestionController)
              .question);
      return MultipleChoiceQuestionContent(
          key: key,
          controller:
              _currentQuestionController as MultipleChoiceQuestionController);
    } else if (_currentQuestionController is CategoryQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as CategoryQuestionController).question);
      return CategoryQuestionContent(
        key: key,
        controller: _currentQuestionController as CategoryQuestionController,
        scrollController: _scrollController,
      );
    } else if (_currentQuestionController is TextInputQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as TextInputQuestionController).question);
      return TextInputQuestionContent(
          key: key,
          controller:
              _currentQuestionController as TextInputQuestionController);
    } else if (_currentQuestionController is ReadingQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as ReadingQuestionController).question);
      return ReadingQuestionContent(
          key: key,
          controller: _currentQuestionController as ReadingQuestionController);
    } else if (_currentQuestionController is MissingWordQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as MissingWordQuestionController)
              .question);
      return MissingWordQuestionContent(
          key: key,
          controller:
              _currentQuestionController as MissingWordQuestionController);
    } else if (_currentQuestionController is ListeningQuestionController) {
      final key = ValueKey(
          (_currentQuestionController as ListeningQuestionController).question);
      return ListeningQuestionContent(
          key: key,
          controller:
              _currentQuestionController as ListeningQuestionController);
    }
    return Container();
  }

  void _submitAnswer() async {
    if (_currentQuestionController?.isAnswered() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please answer the question before submitting.")),
      );
      return;
    }

    final part = widget.testController.currentPart;

    if (part.isLastQuestion) {
      bool shouldContinue = await widget.onPartFinished(part);
      if (!shouldContinue || widget.testController.isLastPart) {
        await widget.onTestEnded();
        return;
      }

      widget.testController.nextPart();
    } else {
      part.nextQuestion();
    }

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: ScrollConfiguration(
          behavior: NoScrollbarBehavior(),
          child: SingleChildScrollView(
            controller: _scrollController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(ThemeDefaults.padding),
            child: Column(
              children: [
                Center(
                    child: Text(widget.label,
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center)),
                const SizedBox(
                  height: 64,
                ),
                Padding(
                  padding: const EdgeInsets.all(ThemeDefaults.padding),
                  child: _buildQuestionWidget(),
                ),
                const SizedBox(height: 64),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitAnswer,
                    child: const Text(AppStrings.submit),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
