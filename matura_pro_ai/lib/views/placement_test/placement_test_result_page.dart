import 'package:flutter/material.dart';
import '../../models/account.dart';

class PlacementTestResultPage extends StatelessWidget {
  final Account account;
  final double score;

  const PlacementTestResultPage({
    super.key,
    required this.account,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Result")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Well done, ${account.name}!",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Your score: ${score.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, score);
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}