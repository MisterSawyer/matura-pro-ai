import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/widgets/scrollable_layout.dart';

void main() {
  testWidgets('ScrollableLayout constrains width', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ScrollableLayout(
        maxWidth: 200,
        children: [Text('item')],
      ),
    ));

    final constrained = tester.widget<ConstrainedBox>(
      find.byWidgetPredicate(
          (w) => w is ConstrainedBox && w.constraints.maxWidth == 200),
    );
    expect(constrained.constraints.maxWidth, 200);
    expect(find.text('item'), findsOneWidget);
  });
}
