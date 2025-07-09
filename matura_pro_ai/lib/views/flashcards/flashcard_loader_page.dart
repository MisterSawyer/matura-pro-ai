import 'package:flutter/material.dart';

import '../../services/flashcard_loader.dart';

import '../../models/flashcard_deck.dart';
import '../../models/account.dart';

import '../../controllers/flashcard_controller.dart';
import '../../widgets/flashcard_view.dart';

import '../../routes/app_routes.dart';

class FlashcardLoaderPage extends StatefulWidget {
  final Account account;

  const FlashcardLoaderPage({super.key, required this.account});

  @override
  State<FlashcardLoaderPage> createState() => _FlashcardLoaderPageState();
}

class _FlashcardLoaderPageState extends State<FlashcardLoaderPage> {
  FlashcardDeck? _deck;
  FlashcardController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDeck();
  }

  Future<void> _loadDeck() async {
    try {
      final loadedDeck = await loadFlashcardDeck('sample_deck.json');
      setState(() {
        _deck = loadedDeck;
        _controller = FlashcardController(loadedDeck);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _deck = null;
        _controller = null;
        _loading = false;
      });
    }
  }

  Future<void> _handleFinished(BuildContext context) async {
    await Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: {'account': widget.account},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_deck == null || _controller == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load flashcards.")),
      );
    }

    return FlashcardView(
      controller: _controller!,
      onFinished: () => _handleFinished(context),
    );
  }
}
