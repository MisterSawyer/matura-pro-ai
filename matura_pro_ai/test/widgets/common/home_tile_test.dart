import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/widgets/home_tile.dart';

void main() {
  testWidgets('HomeTile shows label and handles tap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: HomeTile(
          label: 'Label',
          icon: const Icon(Icons.add),
          onTap: () => tapped = true,
        ),
      ),
    ));

    expect(find.text('Label'), findsOneWidget);

    await tester.tap(find.byType(HomeTile));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
