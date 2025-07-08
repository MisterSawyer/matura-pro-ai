import 'question_type.dart';

class Question {
  final QuestionType type;

  Question({
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final type = QuestionType.fromString(json['type'] as String);
    return Question(type: type);
  }
}
