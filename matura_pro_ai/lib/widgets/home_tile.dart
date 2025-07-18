import 'package:flutter/material.dart';

import '../../core/theme_defaults.dart';

class HomeTile extends StatelessWidget {
  final String label;
  final Icon icon; 
  final VoidCallback? onTap;

  const HomeTile({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(ThemeDefaults.padding),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(label, style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
        );
  }
}
