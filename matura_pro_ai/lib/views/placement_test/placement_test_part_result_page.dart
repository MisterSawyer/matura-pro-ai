import 'package:flutter/material.dart';

import '../../models/account.dart';

import '../../widgets/no_scrollbar.dart';
import '../../controllers/test_part_controller.dart';
import '../../widgets/speedometer_gauge.dart';

class PlacementTestPartResultPage extends StatelessWidget {
  final Account account;
  final TestPartController part;
  final Future<void> Function() onExit;


  const PlacementTestPartResultPage({
    super.key,
    required this.account,
    required this.part,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = part.evaluate() * 100.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ScrollConfiguration(
          behavior: NoScrollbarBehavior(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Center(child : Text("Podsumowanie", style : theme.textTheme.titleLarge, textAlign: TextAlign.center)),
              const SizedBox(height: 64,),
                  Text(
                    part.name,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 64),
                  SpeedometerGauge(
                    value: score,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true); // Continue to next part
                    },
                    child: const Text("Continue"),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context, false); // Close the part result page
                      await onExit();
                    },
                    child: const Text("Exit Test"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
