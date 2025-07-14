import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/widgets/daily_challenge_card.dart';

void main() {
  testWidgets('DailyChallengeCard reacts to tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: DailyChallengeCard(
          currentStreak: 5,
          onTap: () => tapped = true,
        ),
      ),
    ));

    await tester.tap(find.byType(DailyChallengeCard));
    await tester.pump();

    expect(tapped, isTrue);
    expect(find.text('5'), findsOneWidget);
  });
}
