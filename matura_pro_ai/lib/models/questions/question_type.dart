enum QuestionType 
{
  multipleChoice,
  reading,
  textInput,
  category,
  missingWord;


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
      default:
        throw ArgumentError('Invalid QuestionType: $value');
    }
  }

}