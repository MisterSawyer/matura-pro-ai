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
        return "Multiple choice";
      case QuestionType.reading:
        return "Reading";
      case QuestionType.textInput:
        return "Text input";
      case QuestionType.category:
        return "Category";
      case QuestionType.missingWord:
        return "Missing word";
      case QuestionType.listening:
        return "Listening";
    }
  }

}