import 'package:flutter/material.dart';

class DailyChallengeCard extends StatelessWidget {
  final int currentStreak;
  final VoidCallback onTap;

  const DailyChallengeCard({
    super.key,
    required this.currentStreak,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Ink(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSquareBox(
              context,
              child: Text(
                '$currentStreak',
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 96),
              ),
            ),
            const SizedBox(width: 12),
            _buildSquareBox(
              context,
              child: const Text(
                '🔥',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareBox(BuildContext context,
      {required Widget child}) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: child,
    );
  }
}
