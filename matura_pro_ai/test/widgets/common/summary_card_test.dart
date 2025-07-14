import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/widgets/summary_card.dart';

void main() {
  testWidgets('SummaryCard displays info and taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: SummaryCard(
          icon: Icons.add,
          title: 'Title',
          value: '1',
          subtitle: 'sub',
          onTap: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('sub'), findsOneWidget);

    await tester.tap(find.byType(SummaryCard));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
