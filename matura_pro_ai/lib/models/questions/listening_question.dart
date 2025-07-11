import '../tags.dart';
import 'question.dart';
import 'question_type.dart';

import 'multiple_choice_question.dart';
import 'category_question.dart';
import 'text_input_question.dart';
import 'missing_word_question.dart';

class ListeningQuestion extends Question {
  final String question;
  final String audioPath;
  final List<Question> questions;

  ListeningQuestion({
    required super.type,
    required super.tags,
    required this.question,
    required this.audioPath,
    required this.questions,
  });

  factory ListeningQuestion.fromJson(Map<String, dynamic> json) {
    if (json['type'] != 'listening') {
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

    return ListeningQuestion(
      type: QuestionType.fromString(json['type']),
      tags: Tags.fromJson(json['tags']),
      question: json['question'],
      audioPath: json['audioPath'],
      questions: questions,
    );
  }
}
