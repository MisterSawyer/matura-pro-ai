import 'questions/question_topic.dart';

class Topics extends Iterable<QuestionTopic> {
  final List<QuestionTopic> _topics;

  Topics(List<QuestionTopic> topics) : _topics = topics;

  factory Topics.fromJson(dynamic json) {
    if (json is! List) {
      throw const FormatException("Invalid JSON format for Topics: expected List<String>");
    }

    List<QuestionTopic> topics = [];
    for (final obj in json) {
      if (obj is! String) {
        throw const FormatException("Invalid JSON format for Topics: expected List<String>");
      }
      topics.add(QuestionTopic.fromString(obj));
    }

    return Topics(topics);
  }

  List<String> toJson() => _topics.map((e) => e.toString()).toList();

  @override
  Iterator<QuestionTopic> get iterator => _topics.iterator;
}
