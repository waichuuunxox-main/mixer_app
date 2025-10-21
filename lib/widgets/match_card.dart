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
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${match.homeTeam} vs ${match.awayTeam}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 6),
                  Text('${match.date.toLocal()}'.split(' ')[0], style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onBackground)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Score badge / placeholder
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.colorScheme.secondary.withAlpha(46)),
                boxShadow: [
                  BoxShadow(color: theme.shadowColor.withAlpha(16), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: isPlayed
                  ? Text('${match.homeScore} - ${match.awayScore}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary))
                  : Icon(Icons.sports_soccer, color: theme.colorScheme.primary, size: 20),
            )
          ],
        ),
      ),
    );
  }
}
