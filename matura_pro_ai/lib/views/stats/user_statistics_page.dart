import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/user_stats.dart'; // if needed separately

import '../../widgets/speedometer_gauge.dart';

class UserStatisticsPage extends StatelessWidget {
  final Account account;

  const UserStatisticsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = account.stats;
    final results = stats.placementTestResult.partResults;
    final labels = stats.placementTestResult.partNames;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                if (!stats.placementTestTaken)
                  const Text(
                    "You have not taken the placement test yet.",
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  )
                else ...[
                  Text(
                    "Placement Test Results",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(radius: 32, child: Center(child: Text("${index + 1}" , textAlign: TextAlign.center,))),
                        title: Text(labels[index]),
                        trailing: Text("${(results[index] * 100.0).toStringAsFixed(1)}%", style: theme.textTheme.bodyLarge,),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
            Center(
              child: SpeedometerGauge(value: _calculateAverage(results) * 100),
            ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateAverage(List<double> scores) {
    if (scores.isEmpty) return 0;
    final total = scores.reduce((a, b) => a + b);
    return total / scores.length;
  }
}
