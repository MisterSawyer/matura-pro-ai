import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/account.dart';
import '../../models/questions/question_topic.dart';
import '../../models/flashcard/flashcard_deck.dart';

import '../../widgets/scrollable_layout.dart';
import 'flashcard_deck_page.dart';

class FlashcardTopicSelectionPage extends StatelessWidget {
  final Account account;
  final FlashcardDeck deck;

  const FlashcardTopicSelectionPage({
    super.key,
    required this.account,
    required this.deck,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const topics = QuestionTopic.values;

    return Scaffold(
      appBar: AppBar(),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              AppStrings.chooseFlashcardsTopic,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,      // 2 cards per row
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,    // square tiles
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final topic = topics[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardDeckPage(
                        account: account,
                        topic: topic,
                        deck: deck,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
            CircleAvatar(
                  radius: 20,
                  child: Icon(QuestionTopic.getIcon(topic),),
                ),

                        const SizedBox(height: 12),
                        Text(
                          QuestionTopic.stringDesc(topic),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
