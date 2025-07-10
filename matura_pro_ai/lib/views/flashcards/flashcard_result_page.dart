import 'package:flutter/material.dart';
import 'package:matura_pro_ai/core/theme_defaults.dart';

import '../../core/constants.dart';
import '../../models/account.dart';
import '../../routes/app_routes.dart';
import '../../widgets/speedometer_gauge.dart';

import '../../widgets/scrollable_layout.dart';

import '../../controllers/flashcard_controller.dart';

import 'flashcard_deck_page.dart';

class FlashcardResultPage extends StatelessWidget {
  final Account account;
  final FlashcardController controller;

  const FlashcardResultPage({
    super.key,
    required this.account,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (controller.correctAnswers / controller.totalCards * 100);

    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: ScrollableLayout(
          maxWidth: 400,
          children: [
            Center(
                child: Text(controller.deck.name,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center)),
            const SizedBox(height: 32),
            Center(
              child: Text("Great job, ${account.name}!",
                  style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: ThemeDefaults.padding),
            Center(
              child: Text(
                  "You got ${controller.correctAnswers} out of ${controller.totalCards} cards correct.",
                  style: theme.textTheme.titleSmall),
            ),
            const SizedBox(height: 32),
            Center(
              child: SpeedometerGauge(
                value: percent,
              ),
            ),
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
                        deck: controller.deck,
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
        ));
  }
}
