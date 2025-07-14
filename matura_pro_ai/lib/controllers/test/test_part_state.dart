import '../../models/test/test_part.dart';

class TestPartState {
  final TestPart part;
  final int currentQuestion;

  const TestPartState({required this.part, this.currentQuestion = 0});

  bool get isLastQuestion => currentQuestion >= part.questions.length - 1;

  TestPartState copyWith({TestPart? part, int? currentQuestion}) {
    return TestPartState(
      part: part ?? this.part,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }
}
