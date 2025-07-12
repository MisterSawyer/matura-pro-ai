import '../tags.dart';
import '../topics.dart';

import 'question.dart';
import 'question_type.dart';

import '../text_segment.dart';

class MissingWordQuestion extends Question {
  final String question;
  final List<List<String>> items; // options for each blank
  final Map<int, int> correctMatches; // blankIndex -> selectedOptionIndex
  final List<TextSegment> segments;

  MissingWordQuestion({
    required super.type,
    required super.tags,
    required super.topics,
    required this.question,
    required String text,
    required this.items,
    required this.correctMatches,
  }): segments = _parseTextSegments(text);

  static List<TextSegment> _parseTextSegments(String text) {
    final RegExp pattern = RegExp(r'\$\{(\d+)\}');
    final List<TextSegment> segments = [];

    int lastMatchEnd = 0;

    for (final match in pattern.allMatches(text)) {
      final start = match.start;
      final end = match.end;
      final gapIndex = int.parse(match.group(1)!);

      if (start > lastMatchEnd) {
        segments.add(TextSegment.text(text.substring(lastMatchEnd, start)));
      }

      segments.add(TextSegment.gap(gapIndex));
      lastMatchEnd = end;
    }

    if (lastMatchEnd < text.length) {
      segments.add(TextSegment.text(text.substring(lastMatchEnd)));
    }

    return segments;
  }

  factory MissingWordQuestion.fromJson(Map<String, dynamic> json) {
    return MissingWordQuestion(
      type: QuestionType.fromString(json['type'] as String),
      tags: Tags.fromJson(json['tags']),
      topics: Topics.fromJson(json['topics']),
      question: json['question'],
      text: json['text'],
      items: (json['items'] as List)
          .map((group) => List<String>.from(group))
          .toList(),
      correctMatches: (json['correctMatches'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value as int)),
    );
  }
}
