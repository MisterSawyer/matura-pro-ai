import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/flashcard_loader.dart';
import '../../providers/account_provider.dart';

import '../../widgets/scrollable_layout.dart';
import 'flashcard_topic_selection_page.dart';

class FlashcardCategorySelectionPage extends ConsumerWidget {
  const FlashcardCategorySelectionPage({super.key});

  final List<Map<String, String>> decks = const [
    {'label': 'Sample Deck', 'path': 'sample_deck.json'},
    {'label': 'Grammar Basics', 'path': 'grammar_basics.json'},
    {'label': 'Vocabulary', 'path': 'vocabulary.json'},
  ];

  Future<void> _openDeck(BuildContext context, WidgetRef ref, String path) async {
    final account = ref.read(accountProvider);
    if (account == null) return;

    final deck = await loadFlashcardDeck(path);

    if (!context.mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FlashcardTopicSelectionPage(
          account: account,
          deck: deck,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              "Kategorie",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
                onTap: () => _openDeck(context, ref, deck['path']!),
              );
            },
          ),
        ],
      ),
    );
  }
}
