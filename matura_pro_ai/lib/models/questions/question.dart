import '../tags.dart';
import '../topics.dart';

import 'question_type.dart';

class Question {
  final QuestionType type;
  final Tags tags;
  final Topics topics;

  Question({
    required this.type,
    required this.tags,
    required this.topics,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final type = QuestionType.fromString(json['type'] as String);
    return Question(type: type, tags: Tags.fromJson(json['tags']), topics: Topics.fromJson(json['topics']));
  }
}
