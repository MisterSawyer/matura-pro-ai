import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import '../models/questions/question_type.dart';

import '../core/theme_defaults.dart';

import '../models/account.dart';

import '../controllers/test_controller.dart';
import '../controllers/test_part_controller.dart';

import '../controllers/questions/category_question_controller.dart';
import '../controllers/questions/multiple_choice_question_controller.dart';
import '../controllers/questions/text_input_question_controller.dart';
import '../controllers/questions/reading_question_controller.dart';
import '../controllers/questions/missing_word_question_controller.dart';

import 'no_scrollbar.dart';

import 'questions/multiple_choice_question_content.dart';
import 'questions/text_input_question_content.dart';
import 'questions/category_question_content.dart';
import 'questions/reading_question_content.dart';
import 'questions/missing_word_question_content.dart';

class TestPage extends StatefulWidget {
  final String filename;
  final String label;
  final Account account;

  final void Function(double) onSubmit;
  final void Function(TestPartController) onPartFinished;

  const TestPage(
      {super.key,
      required this.filename,
      required this.label,
      required this.onSubmit,
      required this.onPartFinished,
      required this.account});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final TestController _testController;

  final ScrollController _scrollController = ScrollController();

  bool _cancelled = false;

  @override
  void initState() {
    super.initState();
    _testController = TestController();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final jsonString =
        await rootBundle.loadString('assets/tests/${widget.filename}');
    final jsonObj = json.decode(jsonString) as List<dynamic>;

    await _testController.load(jsonObj);

    // Automatically launch the first question after frame is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serveQuestion();
    });
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

  Future<void> _serveQuestion() async {
    if (_cancelled) {
      return;
    }

    final part = _testController.currentPart;
    final controller = part.currentQuestionController();

    if (_testController.isLastPart && part.isLastQuestion) {
      widget.onSubmit(0);
      return;
    }

    if (controller == null) {
      _testController.nextPart();
      await _serveQuestion();
      return;
    }

    late final QuestionType questionType;
    StatefulWidget? questionWidget;
    if (controller is MultipleChoiceQuestionController) {
      questionWidget = MultipleChoiceQuestionContent(controller: controller);
      questionType = QuestionType.multipleChoice;
    }
    if (controller is CategoryQuestionController) {
      questionWidget = CategoryQuestionContent(
        controller: controller);
      questionType = QuestionType.category;
    }
    if (controller is TextInputQuestionController) {
      questionWidget = TextInputQuestionContent(
        controller: controller);
      questionType = QuestionType.textInput;
    }
    if (controller is ReadingQuestionController) {
      questionWidget = ReadingQuestionContent(
        controller: controller);
      questionType = QuestionType.reading;
    }

    if (controller is MissingWordQuestionController) {
      questionWidget = MissingWordQuestionContent(
        controller: controller);
      questionType = QuestionType.missingWord;
    }

    if (questionWidget == null) {
      return;
    }

    final result = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false, title: Text(widget.label)),
          body: ScrollConfiguration(
            behavior: NoScrollbarBehavior(),
            child: SingleChildScrollView(
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(ThemeDefaults.padding),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(ThemeDefaults.padding),
                    child: questionWidget,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if(controller.isAnswered() == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please answer the question before submitting.")),
                          );
                          return;
                        }
                        Navigator.pop(context, controller.evaluate());
                      },
                      
                      child: const Text("Submit"),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == null) {
      _onCancel();
      return;
    }

    if (part.isLastQuestion) {
      widget.onPartFinished(_testController.currentPart);
      _testController.nextPart();
    } else {
      part.nextQuestion();
    }

    await _serveQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
          appBar: AppBar(title: Center(child:Text(widget.label))),
          body: const Padding(
              padding: EdgeInsets.all(ThemeDefaults.padding),
              child: Center(child: CircularProgressIndicator()))),
    );
  }
}
