import '../../core/constants.dart';

enum QuestionType 
{
  multipleChoice,
  reading,
  textInput,
  category,
  missingWord,
  listening;


  static QuestionType fromString(String value) {
    switch (value) {
      case 'multiple_choice':
        return QuestionType.multipleChoice;
      case 'reading':
        return QuestionType.reading;
      case 'text_input':
        return QuestionType.textInput;
      case 'category':
        return QuestionType.category;
      case 'missing_word':
        return QuestionType.missingWord;
      case 'listening':
        return QuestionType.listening;
      default:
        throw ArgumentError('Invalid QuestionType: $value');
    }
  }

  static String stringDesc(QuestionType type)
  {
    switch (type) {
      case QuestionType.multipleChoice:
        return AppStrings.multipleChoice;
      case QuestionType.reading:
        return AppStrings.reading;
      case QuestionType.textInput:
        return AppStrings.textInput;
      case QuestionType.category:
        return AppStrings.category;
      case QuestionType.missingWord:
        return AppStrings.missingWord;
      case QuestionType.listening:
        return AppStrings.listening;
    }
  }

}