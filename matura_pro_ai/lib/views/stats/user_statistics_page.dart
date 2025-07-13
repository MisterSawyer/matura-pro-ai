import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/test_result.dart';
import '../../models/test_type.dart';

import '../../controllers/test_controller.dart';
import '../../widgets/speedometer_gauge.dart';

import '../../widgets/scrollable_layout.dart';
import '../../widgets/tags_and_topics_results_view.dart';

class UserStatisticsPage extends StatelessWidget {
  final Account account;

  const UserStatisticsPage({super.key, required this.account});

  Widget _buildTestResultCard(BuildContext context, TestResult testResult) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                testResult.name,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: testResult.partNames.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final label = testResult.partNames[index];
                final score = testResult.partResults[index];
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
                value: testResult.average * 100.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingTestCard(
      BuildContext context, TestType type, TestController controller) {
    final theme = Theme.of(context);
    final part = controller.currentPart;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                controller.test.name,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text(part.name, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center)),
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              value: null, // infinite to indicate in-progress
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = account.stats;
    final results = stats.testResults; // [TestType, TestResult]

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
          if (account.currentTests.isNotEmpty) ...[
            Text("Trwające testy:", style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...account.currentTests.entries.map((entry) {
              return _buildOngoingTestCard(context, entry.key, entry.value);
            }),
            const Divider(),
          ],
          TagsAndTopicsResultsView(results: stats.tagsAndTopicsResults),
          const Divider(),
          Column(
            children: results.entries.map((entry) {
              final testList = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...testList.reversed
                      .map((result) => _buildTestResultCard(context, result)),
                  const Divider(height: 48),
                ],
              );
            }).toList(),
          ),
        ]));
  }
}
