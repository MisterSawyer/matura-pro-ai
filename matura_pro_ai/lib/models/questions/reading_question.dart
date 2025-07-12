import '../tags.dart';
import '../topics.dart';

import 'question.dart';
import 'question_type.dart';

import 'multiple_choice_question.dart';
import 'category_question.dart';
import 'text_input_question.dart';
import 'missing_word_question.dart';

class ReadingQuestion extends Question {
  final String question;
  final String text;
  final List<Question> questions;

  ReadingQuestion({
    required super.type,
    required super.tags,
    required super.topics,
    required this.question,
    required this.text,
    required this.questions,
  });

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'reading') {
      throw Exception('Invalid question type: ${json['type']}');
    }

    final List<Question> questions = [];
    for(int i = 0; i < json['questions'].length; i++)
    {
      switch (QuestionType.fromString(json['questions'][i]['type'] as String))
      {
        case QuestionType.multipleChoice:
          questions.add(MultipleChoiceQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.category:
          questions.add(CategoryQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.textInput :
          questions.add(TextInputQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.missingWord :
          questions.add(MissingWordQuestion.fromJson(json['questions'][i]));
          break;
        default : 
          throw Exception('Invalid question type: ${json['questions'][i]['type']}');
      }
    }

    return ReadingQuestion(
      type : QuestionType.fromString(json['type'] as String),
      tags: Tags.fromJson(json['tags']),
      topics: Topics.fromJson(json['topics']),
      question: json['question'] as String,
      text: json['text'] as String,
      questions: questions
    );
  }
}
