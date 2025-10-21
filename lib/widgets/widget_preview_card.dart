import 'package:flutter/material.dart';

class WidgetPreviewCard extends StatelessWidget {
  final String nextMatch;
  final DateTime timestamp;

  const WidgetPreviewCard({super.key, required this.nextMatch, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Next match', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(nextMatch, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: 8),
            Text('Updated: ${timestamp.toLocal().toIso8601String()}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
