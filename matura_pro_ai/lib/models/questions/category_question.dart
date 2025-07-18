import '../tags.dart';
import '../topics.dart';

import 'question.dart';
import 'question_type.dart';

class CategoryQestionAnswer extends QuestionAnswer
{
  final Map<int, int> data = {};
}

class CategoryQuestion extends Question {
  final String question;
  final List<String> items;
  final List<String> categories;
  final Map<int, int> correctMatches; // itemIndex -> categoryIndex

  CategoryQuestion({
    required super.type,
    required super.tags,
    required super.topics,
    required this.question,
    required this.items,
    required this.categories,
    required this.correctMatches,
  });

  factory CategoryQuestion.fromJson(Map<String, dynamic> json) {
    final rawMatches = (json['correctMatches'] as Map).map(
      (k, v) => MapEntry(int.parse(k), v as int),
    );

    return CategoryQuestion(
      type: QuestionType.fromString(json['type'] as String),
      tags: Tags.fromJson(json['tags']),
      topics: Topics.fromJson(json['topics']),
      question: json['question'],
      items: List<String>.from(json['items']),
      categories: List<String>.from(json['categories']),
      correctMatches: rawMatches,
    );
  }
}