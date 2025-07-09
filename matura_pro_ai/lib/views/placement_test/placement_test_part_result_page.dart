import 'package:flutter/material.dart';

import '../../models/account.dart';

import '../../controllers/test_part_controller.dart';

class PlacementTestPartResultPage extends StatelessWidget {
  final Account account;
  final TestPartController part;
  final Future<void> Function(double) onExit;


  const PlacementTestPartResultPage({
    super.key,
    required this.account,
    required this.part,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final score = part.evaluate() * 100.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Part Result"),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                part.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 64),
              Text(
                "Your score: ${score.toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.titleMedium,
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
                  await onExit(score);
                },
                child: const Text("Exit Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
