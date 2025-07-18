import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../controllers/test/test_part_controller.dart';

import '../../widgets/scrollable_layout.dart';
import '../../widgets/speedometer_gauge.dart';

class PlacementTestPartResultPage extends ConsumerWidget {
  final bool isLastPart;
  final TestPartController part;

  const PlacementTestPartResultPage({
    super.key,
    required this.part,
    this.isLastPart = false,
  });

  Widget _buildActionButtons(BuildContext context) {
    if (isLastPart) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, false); // exit test
          },
          child: const Text(AppStrings.wellDone),
        ),
      );
    }

    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true); // continue to next part
            },
            child: const Text(AppStrings.submit),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, false); // exit test
            },
            child: const Text(AppStrings.exitTest),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final score = part.evaluate() * 100.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              AppStrings.summary,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Center(
            child: Text(
              part.name,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Center(
            child: SpeedometerGauge(value: score),
          ),
          const SizedBox(height: 32),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
