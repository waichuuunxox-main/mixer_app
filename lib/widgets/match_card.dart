import 'package:flutter/material.dart';
import 'package:mixzer_app/models/match.dart' as m;

class MatchCard extends StatelessWidget {
  final m.Match match;
  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final isPlayed = match.homeScore != null && match.awayScore != null;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${match.homeTeam} vs ${match.awayTeam}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('${match.date.toLocal()}'.split(' ')[0], style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: isPlayed
                  ? Text('${match.homeScore} - ${match.awayScore}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
                  : Icon(Icons.sports_soccer, color: theme.colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }
}
