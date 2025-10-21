import 'package:flutter/material.dart';
import 'package:mixzer_app/models/player.dart';

class ScorerCard extends StatelessWidget {
  final Player player;
  const ScorerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(radius: 22, backgroundColor: theme.colorScheme.primary.withAlpha(40), child: Text(player.name.substring(0,1), style: TextStyle(color: theme.colorScheme.onPrimary))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                  const SizedBox(height: 4),
                  Text(player.team, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: theme.colorScheme.secondary.withAlpha(28), borderRadius: BorderRadius.circular(8), border: Border.all(color: theme.colorScheme.secondary.withAlpha(46))),
              child: Text('${player.goals}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            )
          ],
        ),
      ),
    );
  }
}
