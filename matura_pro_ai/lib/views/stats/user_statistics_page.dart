import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/test/test_result.dart';
import '../../models/test/test_type.dart';
import '../../models/test/test_progress.dart';

import '../../providers/account_provider.dart';

import '../../widgets/scrollable_layout.dart';
import '../../widgets/speedometer_gauge.dart';
import '../../widgets/tags_and_topics_results_view.dart';

class UserStatisticsPage extends ConsumerWidget {
  const UserStatisticsPage({super.key});

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
  BuildContext context,
  TestType type,
  TestProgress progress,
) {
  final theme = Theme.of(context);
  final currentPart = progress.test.parts[progress.partID];
  final completedCount = progress.partID;

  final completedPartNames = progress.results.partNames;
  final completedScores = progress.results.partResults;

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 16),
    color: theme.colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              progress.test.name,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          if (completedCount > 0) ...[
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedCount,
              itemBuilder: (context, index) {
                final partName = index < completedPartNames.length
                    ? completedPartNames[index]
                    : 'Sekcja ${index + 1}';
                final score = index < completedScores.length
                    ? "${(completedScores[index] * 100).toStringAsFixed(1)}%"
                    : '-';

                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  title: Text("✓ $partName", style: theme.textTheme.bodySmall),
                  trailing: Text(score, style: theme.textTheme.bodySmall),
                );
              },
            ),
            const Divider(height: 32),
          ],

          Text("Aktualna część:", style: theme.textTheme.bodyLarge),
          const SizedBox(height: 8),
          Center(
            child: Text(
              currentPart.name,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(), // ongoing visual
        ],
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final account = ref.watch(accountProvider);
    final stats = account?.stats;
    final results = stats?.testResults;

    return Scaffold(
      appBar: AppBar(),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              "Statystyki",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          if (account?.currentTests.isNotEmpty ?? false) ...[
            Text("Trwające testy:", style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...account!.currentTests.entries.map(
              (entry) => _buildOngoingTestCard(context, entry.key, entry.value),
            ),
            const Divider(),
          ],
          if (stats != null)
            TagsAndTopicsResultsView(results: stats.tagsAndTopicsResults),
          if (results != null && results.isNotEmpty) ...[
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
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
