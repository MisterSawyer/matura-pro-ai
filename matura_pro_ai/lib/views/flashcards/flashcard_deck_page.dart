import 'package:flutter/material.dart';

import '../../models/flashcard/flashcard_deck.dart';
import '../../models/account.dart';

import '../../widgets/flashcard/flashcard_view.dart';

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
  late final FlashcardDeck _filteredDeck;
  @override
  void initState() {
    super.initState();

   _filteredDeck = widget.topic == null
        ? widget.deck
        : FlashcardDeck(
            name: widget.deck.name,
            cards: widget.deck.cards
                .where((c) => c.topics.contains(widget.topic!))
                .toList());
  }

  Future<void> _handleFinished(
      BuildContext context, TagsAndTopicsResults results) async {
    widget.account.stats.tagsAndTopicsResults += results;

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardResultPage(
          account: widget.account,
          deck: _filteredDeck,
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
            deck: _filteredDeck,
            onFinished: (results) => _handleFinished(context, results),
          )
        ]));
  }
}
