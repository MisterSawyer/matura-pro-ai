import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../controllers/test/test_controller.dart';
import '../../controllers/test/test_part_controller.dart';
import '../../controllers/questions/question_controller.dart';

import '../no_scrollbar.dart';

import '../questions/question_widget_factory.dart';

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

  int _secondsRemaining = 0;
  int _currentDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serveQuestion();
    });
  }

  void _startTimer() {
    final part = widget.testController.currentPart;
    _currentDuration = part.part.duration;
    _secondsRemaining = _currentDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsRemaining <= 0) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() {
        _secondsRemaining--;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _serveQuestion() async {
    final part = widget.testController.currentPart;
    final controller = part.currentQuestion;

    if (controller == null) {
      widget.testController.nextPart();
      _serveQuestion();
      return;
    }

    if (part.currentIndex == 0) {
      _startTimer();
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

    final builder = questionWidgetMap[_currentQuestionController.runtimeType];
    if (builder != null) {
      return builder(_currentQuestionController!);
    } else {
      throw UnsupportedError(
          "Unsupported controller: ${_currentQuestionController.runtimeType}");
    }
  }

  void _submitAnswer() async {
    if (_currentQuestionController?.isAnswered() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.enterAllAnswers)),
      );
      return;
    }

    final part = widget.testController.currentPart;

    if (part.isLastQuestion) {
      bool shouldContinue = await widget.onPartFinished(part);
      if (!shouldContinue || widget.testController.isLastPart) {
        _timer?.cancel();
        await widget.onTestEnded();
        return;
      }

      _timer?.cancel();
      widget.testController.nextPart();
    } else {
      part.nextQuestion();
    }

    _serveQuestion();
  }

  Widget _buildTimerWidget(BuildContext context) {
    if (_currentDuration == 0) return const SizedBox.shrink();
    final progress =
        _currentDuration == 0 ? 0.0 : _secondsRemaining / _currentDuration;
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    final color = progress < 0.2 ? Colors.red : Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        LinearProgressIndicator(value: progress, color: color),
        const SizedBox(height: 4),
        Text('$minutes:$seconds'),
      ],
    );
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
                const SizedBox(height: 16),
                _buildTimerWidget(context),
                const SizedBox(height: 48),
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
