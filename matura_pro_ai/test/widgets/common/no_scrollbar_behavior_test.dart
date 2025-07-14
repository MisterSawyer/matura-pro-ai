import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matura_pro_ai/widgets/no_scrollbar.dart';

void main() {
  testWidgets('NoScrollbarBehavior omits scrollbar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ScrollConfiguration(
        behavior: NoScrollbarBehavior(),
        child: ListView(children: const [Text('A')]),
      ),
    ));

    expect(find.byType(Scrollbar), findsNothing);
  });
}
