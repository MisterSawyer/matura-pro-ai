import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../models/account.dart';
import '../../models/flashcard/flashcard_deck.dart';
import '../../providers/flashcard_provider.dart';

import '../../routes/app_routes.dart';
import '../../widgets/speedometer_gauge.dart';
import '../../widgets/scrollable_layout.dart';

import 'flashcard_deck_page.dart';

class FlashcardResultPage extends ConsumerWidget {
  final Account account;
  final FlashcardDeck deck;

  const FlashcardResultPage({
    super.key,
    required this.account,
    required this.deck,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashcardControllerProvider(deck));
    final theme = Theme.of(context);

    final percent = (state.correctAnswers / state.workingDeck.cards.length) * 100;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              deck.name,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              "Great job, ${account.name}!",
              style: theme.textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: ThemeDefaults.padding),
          Center(
            child: Text(
              "You got ${state.correctAnswers} out of ${state.workingDeck.cards.length} cards correct.",
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 32),
          Center(child: SpeedometerGauge(value: percent)),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashcardDeckPage(
                      account: account,
                      deck: deck,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: ThemeDefaults.padding),
          Center(
            child: TextButton(
              child: const Text(AppStrings.backHome),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                  arguments: {'account': account},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
