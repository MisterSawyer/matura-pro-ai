import '../tags.dart';

import 'question_type.dart';

class Question {
  final Tags tags;
  final QuestionType type;

  Question({
    required this.tags,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final type = QuestionType.fromString(json['type'] as String);
    return Question(type: type, tags: Tags.fromJson(json['tags']));
  }
}
