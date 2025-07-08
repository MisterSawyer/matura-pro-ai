import 'questions/question.dart';
import 'questions/question_type.dart';

import 'questions/multiple_choice_question.dart';
import 'questions/reading_question.dart';
import 'questions/text_input_question.dart';
import 'questions/category_question.dart';
import 'questions/missing_word_question.dart';

class TestPart {
  final String name;
  final List<Question> questions;

  TestPart({
    required this.name,
    required this.questions,
  });

  factory TestPart.fromJson(Map<String, dynamic> json) {
    
    List<Question> questions = [];
    for(int i = 0; i < json['questions'].length; i++)
    {
      switch(QuestionType.fromString(json['questions'][i]['type'] as String))
      {
        case QuestionType.reading:
          questions.add(ReadingQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.multipleChoice:
          questions.add(MultipleChoiceQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.textInput:
          questions.add(TextInputQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.category:
          questions.add(CategoryQuestion.fromJson(json['questions'][i]));
          break;
        case QuestionType.missingWord:
          questions.add(MissingWordQuestion.fromJson(json['questions'][i]));
          break;
      }
    }

    return TestPart(
      name: json['name'] as String,
      questions: questions
    );
  }
}
