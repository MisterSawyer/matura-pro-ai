import 'package:flutter/material.dart';

import '../../models/flashcard_deck.dart';
import '../../models/account.dart';

import '../../controllers/flashcard_controller.dart';
import '../../widgets/flashcard_view.dart';

import 'flashcard_result_page.dart';
import '../../widgets/scrollable_layout.dart';
import '../../models/questions/question_topic.dart';
import '../../models/tags_and_topics_results.dart';

class FlashcardDeckPage extends StatefulWidget {
  final FlashcardDeck deck;
  final QuestionTopic? topic;

  final Account account;

  const FlashcardDeckPage(
      {super.key, required this.account, required this.deck, this.topic});

  @override
  State<FlashcardDeckPage> createState() => _FlashcardDeckPageState();
}

class _FlashcardDeckPageState extends State<FlashcardDeckPage> {
  late final FlashcardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlashcardController(widget.deck);
  }

  Future<void> _handleFinished(BuildContext context, TagsAndTopicsResults results) async {
    widget.account.stats.tagsAndTopicsResults += results;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardResultPage(
          account: widget.account,
          controller: _controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ScrollableLayout(maxWidth: 400, children: [
          FlashcardView(
            controller: _controller,
            onFinished: (tagsAndTopicsResults) => _handleFinished(context, tagsAndTopicsResults),
            topic : widget.topic,
          )
        ]));
  }
}
