import 'package:flutter/material.dart';
import 'package:mixzer_app/widgets/widget_preview_card.dart';
import 'package:mixzer_app/services/widget_sync.dart';

class WidgetPreviewPage extends StatefulWidget {
  const WidgetPreviewPage({super.key});

  @override
  State<WidgetPreviewPage> createState() => _WidgetPreviewPageState();
}

class _WidgetPreviewPageState extends State<WidgetPreviewPage> {
  final TextEditingController _controller = TextEditingController(text: 'Team A vs Team B');
  String get _nextMatch => _controller.text;

  void _writeSummary() async {
    final summary = {'nextMatch': _nextMatch, 'timestamp': DateTime.now().toIso8601String()};
    await WidgetSync.writeSummary(summary);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Widget summary written')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Preview how the widget will look and sync sample data to native widget storage.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: 12),
            WidgetPreviewCard(nextMatch: _nextMatch, timestamp: DateTime.now()),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Next match text'),
              controller: _controller,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _writeSummary, child: const Text('Write summary to widget')),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _controller.text = 'Team X vs Team Y';
                    });
                  },
                  child: const Text('Use sample'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
