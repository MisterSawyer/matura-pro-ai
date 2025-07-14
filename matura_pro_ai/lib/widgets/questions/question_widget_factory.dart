import 'package:flutter/widgets.dart';

import '../../controllers/questions/question_controller.dart';
import '../../controllers/questions/multiple_choice_question_controller.dart';
import '../../controllers/questions/text_input_question_controller.dart';
import '../../controllers/questions/category_question_controller.dart';
import '../../controllers/questions/reading_question_controller.dart';
import '../../controllers/questions/missing_word_question_controller.dart';
import '../../controllers/questions/listening_question_controller.dart';

import '../../widgets/questions/multiple_choice_question_content.dart';
import '../../widgets/questions/text_input_question_content.dart';
import '../../widgets/questions/category_question_content.dart';
import '../../widgets/questions/reading_question_content.dart';
import '../../widgets/questions/missing_word_question_content.dart';
import '../../widgets/questions/listening_question_content.dart';

typedef QuestionWidgetBuilder = Widget Function(QuestionController controller);
final Map<Type, QuestionWidgetBuilder> questionWidgetMap = {
  MultipleChoiceQuestionController: (c) =>
      MultipleChoiceQuestionContent(key : ValueKey((c as MultipleChoiceQuestionController).question), controller: c),
  TextInputQuestionController: (c) =>
      TextInputQuestionContent(key : ValueKey((c as TextInputQuestionController).question), controller: c),
  CategoryQuestionController: (c) =>
      CategoryQuestionContent(key : ValueKey((c as CategoryQuestionController).question), controller: c),
  ReadingQuestionController: (c) =>
      ReadingQuestionContent(key : ValueKey((c as ReadingQuestionController).question), controller: c),
  MissingWordQuestionController: (c) =>
      MissingWordQuestionContent(key : ValueKey((c as MissingWordQuestionController).question), controller: c),
  ListeningQuestionController: (c) =>
      ListeningQuestionContent(key : ValueKey((c as ListeningQuestionController).question), controller: c),
};
