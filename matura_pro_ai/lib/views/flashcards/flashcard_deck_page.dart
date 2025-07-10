import 'package:flutter/material.dart';

import '../../models/flashcard_deck.dart';
import '../../models/account.dart';

import '../../controllers/flashcard_controller.dart';
import '../../widgets/flashcard_view.dart';

import 'flashcard_result_page.dart';
import '../../widgets/scrollable_layout.dart';

class FlashcardDeckPage extends StatefulWidget {
  final FlashcardDeck deck;
  final Account account;

  const FlashcardDeckPage(
      {super.key, required this.account, required this.deck});

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

  Future<void> _handleFinished(BuildContext context) async {
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
            onFinished: () => _handleFinished(context),
          )
        ]));
  }
}
