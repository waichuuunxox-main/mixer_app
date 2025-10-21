import 'package:flutter/material.dart';

class WidgetPreviewCard extends StatelessWidget {
  final String nextMatch;
  final DateTime timestamp;

  const WidgetPreviewCard({super.key, required this.nextMatch, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Next match', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(nextMatch, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Updated: ${timestamp.toLocal().toIso8601String()}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
