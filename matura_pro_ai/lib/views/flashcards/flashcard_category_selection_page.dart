import 'package:flutter/material.dart';
import '../../core/theme_defaults.dart';

import '../../services/flashcard_loader.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';
import '../../core/constants.dart';

import 'flashcard_deck_page.dart';

class FlashcardCategorySelectionPage extends StatelessWidget {
  final Account account;

  const FlashcardCategorySelectionPage({super.key, required this.account});

  final List<Map<String, String>> decks = const [
    {'label': 'Sample Deck', 'path': 'sample_deck.json'},
    {'label': 'Grammar Basics', 'path': 'grammar_basics.json'},
    {'label': 'Vocabulary', 'path': 'vocabulary.json'},
  ];

  void _openDeck(BuildContext context, String path) async {
    if(context.mounted == false)
    {
      return;
    }
    
    final deck = await loadFlashcardDeck(path);
    if(context.mounted == false)
    {
      return;
    }
    final route = MaterialPageRoute(
      builder: (context) => FlashcardDeckPage(
        account: account,
        deck: deck,
      ),
    );

    await Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 32,),
          Center(child : Text("Kategorie fiszek", style : theme.textTheme.titleLarge, textAlign: TextAlign.center)),
          const SizedBox(height: 32,),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeDefaults.padding),
                  child: ListView.separated(
                    itemCount: decks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final deck = decks[index];
                      return ListTile(
                        tileColor: theme.colorScheme.secondaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(deck['label']!),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _openDeck(context, deck['path']!),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
