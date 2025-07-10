import 'package:flutter/material.dart';

import '../../models/account.dart';

import '../../controllers/test_part_controller.dart';
import '../../widgets/speedometer_gauge.dart';
import '../../widgets/scrollable_layout.dart';

class PlacementTestPartResultPage extends StatelessWidget {
  final Account account;
  final bool isLastPart;
  final TestPartController part;
  final Future<void> Function() onExit;

  const PlacementTestPartResultPage({
    super.key,
    required this.account,
    required this.part,
    required this.onExit,
    this.isLastPart = false,
  });

  Widget _buildActionButtons(context) {
    if (isLastPart) {
      return Center(
        child: ElevatedButton(
          onPressed: () async {
            await onExit();
          },
          child: const Text("Exit Test"),
        ),
      );
    }

    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true); // Continue to next part
            },
            child: const Text("Continue"),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: TextButton(
            onPressed: () async {
              Navigator.pop(context, false); // Close the part result page
              await onExit();
            },
            child: const Text("Exit Test"),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = part.evaluate() * 100.0;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: ScrollableLayout(maxWidth: 400, children: [
          Center(
              child: Text("Podsumowanie",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center)),
          const SizedBox(
            height: 64,
          ),
          Center(
            child: Text(part.name,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 64),
          Center(
            child: SpeedometerGauge(
              value: score,
            ),
          ),
          const SizedBox(height: 32),
          _buildActionButtons(context)
        ]));
  }
}
