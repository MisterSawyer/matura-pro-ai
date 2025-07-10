import '../tags.dart';
import 'question.dart';
import 'question_type.dart';

import '../text_segment.dart';

class TextInputQuestion extends Question {
  final String question;
  final String text;
  final List<List<String>> acceptedAnswers; // blankIndex -> list of accepted words
  final List<TextSegment> segments;

  TextInputQuestion({
    required super.type,
    required super.tags,
    required this.question,
    required this.text,
    required this.acceptedAnswers,
  }) : segments = _parseTextSegments(text);

  factory TextInputQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'text_input') {
      throw Exception('Invalid question type: ${json['type']}');
    }

    final rawAnswers = (json['acceptedAnswers'] as List)
        .map((group) => List<String>.from(group))
        .toList();

    final normalizedAnswers = rawAnswers
        .map((group) => group.map((a) => a.trim().toLowerCase()).toList())
        .toList();

    return TextInputQuestion(
      type: QuestionType.fromString(json['type'] as String),
      tags: Tags.fromJson(json['tags']),
      question: json['question'] as String,
      text: json['text'] as String,
      acceptedAnswers: normalizedAnswers,
    );
  }

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
}
