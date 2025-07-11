import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../widgets/speedometer_gauge.dart';

import '../../widgets/scrollable_layout.dart';

class UserStatisticsPage extends StatelessWidget {
  final Account account;

  const UserStatisticsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = account.stats;
    final results = stats.placementTestResult;

    return Scaffold(
        appBar: AppBar(),
        body: ScrollableLayout(maxWidth: 400, children: [
          Center(
              child: Text("Statystyki",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center)),
          const SizedBox(
            height: 32,
          ),
          if (!stats.placementTestTaken)
            const Text(
              "You have not completed any tests yet.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            )
          else
            Column(
              children: List.generate(results.length, (testIndex) {
                // reverse order
                final test = results[results.length - 1 - testIndex];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            test.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: test.partNames.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final label = test.partNames[index];
                            final score = test.partResults[index];
                            return ListTile(
                              title: Text(label),
                              trailing: Text(
                                "${(score * 100).toStringAsFixed(1)}%",
                                style: theme.textTheme.bodyLarge,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: SpeedometerGauge(
                            value: test.average * 100.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
        ]));
  }
}
