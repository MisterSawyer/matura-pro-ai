import '../tags.dart';
import '../topics.dart';

import 'question.dart';
import 'question_type.dart';

class MultipleChoiceQuestion extends Question {
  final String question;
  final List<String> options;
  final List<int> correctIndexes;

  MultipleChoiceQuestion({
    required super.type,
    required super.tags,
    required super.topics,
    required this.question,
    required this.options,
    required this.correctIndexes,
  });

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'multiple_choice') {
      throw Exception('Invalid question type: ${json['type']}');
    }

    return MultipleChoiceQuestion(
      type : QuestionType.fromString(json['type'] as String),
      tags: Tags.fromJson(json['tags']),
      topics: Topics.fromJson(json['topics']),
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctIndexes: List<int>.from(json['correctIndexes']),
    );
  }
}
