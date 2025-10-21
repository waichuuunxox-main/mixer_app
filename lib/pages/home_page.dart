import 'package:flutter/material.dart';
import 'package:mixzer_app/services/mock_service.dart';
import 'package:mixzer_app/services/api_helper.dart';
import 'package:mixzer_app/services/data_repository.dart';
import 'package:mixzer_app/widgets/match_card.dart';
import 'package:mixzer_app/widgets/scorer_card.dart';
import 'package:mixzer_app/services/widget_sync.dart';
import 'package:mixzer_app/pages/widget_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final MockService _service = MockService();
  bool _useMock = true;
  String? _apiKey;
  final bool _autoSyncEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Auto-sync at startup if enabled
    if (_autoSyncEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _autoSync());
    }
    // load stored API key
    ApiHelper.readApiKey().then((key) {
      if (!mounted) return;
      setState(() {
        _apiKey = key.isNotEmpty ? key : null;
        _useMock = _apiKey == null;
      });
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List> _fetchMatches() async {
    // Use DataRepository which decides between ApiService and MockService
    try {
      return await DataRepository.fetchMatches(useCache: true);
    } catch (e) {
      return await _service.fetchMatches();
    }
  }

  Future<void> _autoSync() async {
    if (!mounted) return;
    final matches = await _fetchMatches();
    final upcoming = matches.where((m) => m.homeScore == null && m.awayScore == null).toList()..sort((a,b) => a.date.compareTo(b.date));
    final next = upcoming.isNotEmpty ? upcoming.first : (matches.isNotEmpty ? matches.first : null);
    final nextMatchText = next != null ? '${next.homeTeam} vs ${next.awayTeam}' : 'No upcoming match';
    final summary = {
      'nextMatch': nextMatchText,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await WidgetSync.writeSummary(summary);
  }

  Future<void> _performRefresh() async {
    try {
      final matches = await _fetchMatches();
      final upcoming = matches.where((m) => m.homeScore == null && m.awayScore == null).toList()..sort((a,b) => a.date.compareTo(b.date));
      final next = upcoming.isNotEmpty ? upcoming.first : (matches.isNotEmpty ? matches.first : null);
      final nextMatchText = next != null ? '${next.homeTeam} vs ${next.awayTeam}' : 'No upcoming match';
      await WidgetSync.writeSummary({'nextMatch': nextMatchText, 'timestamp': DateTime.now().toIso8601String()});
    } catch (e) {
      // swallow; RefreshIndicator will show if needed via UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mixzer'),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync widget',
            onPressed: () async {
              // Ensure context is captured before any await to avoid using BuildContext across async gaps
              if (!mounted) return;
              final messenger = ScaffoldMessenger.of(context);

              // Build summary from next upcoming match
              final matches = await _fetchMatches();
              final upcoming = matches.where((m) => m.homeScore == null && m.awayScore == null).toList()..sort((a,b) => a.date.compareTo(b.date));
              final next = upcoming.isNotEmpty ? upcoming.first : (matches.isNotEmpty ? matches.first : null);
              final nextMatchText = next != null ? '${next.homeTeam} vs ${next.awayTeam}' : 'No upcoming match';
              final summary = {
                'nextMatch': nextMatchText,
                'timestamp': DateTime.now().toIso8601String(),
              };

              try {
                await WidgetSync.writeSummary(summary);
                messenger.showSnackBar(SnackBar(content: const Text('Widget summary written'), backgroundColor: Theme.of(context).colorScheme.primary));
              } catch (e) {
                messenger.showSnackBar(SnackBar(content: Text('Failed to write widget summary: $e'), backgroundColor: Colors.red.shade700));
              }
            },
          ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  tooltip: 'Widget preview',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WidgetPreviewPage()));
                  },
                ),
              IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
                  // show API key dialog
                  if (!mounted) return;
                  final messenger = ScaffoldMessenger.of(context);
                  final key = await showDialog<String?>(context: context, builder: (ctx) {
                    String input = _apiKey ?? '';
                    return AlertDialog(
                      title: const Text('API Key'),
                      content: TextField(
                        controller: TextEditingController(text: input),
                        decoration: const InputDecoration(hintText: 'Enter API key (leave blank to use mock)'),
                        onChanged: (v) => input = v,
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.of(ctx).pop(input), child: const Text('Save')),
                      ],
                    );
                  });
                  if (key != null) {
                    // persist API key
                    await ApiHelper.saveApiKey(key);
                    setState(() {
                      _apiKey = key.isNotEmpty ? key : null;
                      _useMock = _apiKey == null;
                    });
                    messenger.showSnackBar(SnackBar(content: Text(_apiKey != null ? 'API key saved' : 'API key cleared; using mock')));
                  }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text('Mock'),
                Switch(
                  value: _useMock,
                  onChanged: (v) {
                    setState(() {
                      _useMock = v;
                    });
                  },
                ),
                const Text('API'),
              ],
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Results'), Tab(text: 'Fixtures'), Tab(text: 'Scorers')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Results
          RefreshIndicator(
            onRefresh: _performRefresh,
            child: FutureBuilder(
                future: DataRepository.fetchMatches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data;
                final matches = (data as List?)?.cast() ?? <dynamic>[];
                if (matches.isEmpty) return const Center(child: Text('No results'));
                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) => MatchCard(match: matches[index]),
                );
              },
            ),
          ),

          // Fixtures
          FutureBuilder(
            future: DataRepository.fetchMatches(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data;
              final matches = (data as List?)?.cast() ?? <dynamic>[];
              final fixtures = matches.where((m) => (m.homeScore == null && m.awayScore == null)).toList();
              if (fixtures.isEmpty) return const Center(child: Text('No fixtures'));
              return ListView.builder(
                itemCount: fixtures.length,
                itemBuilder: (context, index) => MatchCard(match: fixtures[index]),
              );
            },
          ),

          // Scorers
          FutureBuilder(
            future: DataRepository.fetchTopScorers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data;
              final scorers = (data as List?)?.cast() ?? <dynamic>[];
              if (scorers.isEmpty) return const Center(child: Text('No scorers'));
              return ListView.builder(
                itemCount: scorers.length,
                itemBuilder: (context, index) => ScorerCard(player: scorers[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
