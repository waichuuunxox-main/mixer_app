import 'package:flutter/material.dart';

class TodayCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const TodayCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: theme.shadowColor.withAlpha(12), blurRadius: 10, offset: const Offset(0,4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                const SizedBox(height: 6),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
          ),
          Icon(Icons.sports_soccer, size: 36, color: theme.colorScheme.secondary),
        ],
      ),
    );
  }
}
