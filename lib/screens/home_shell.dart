import 'package:flutter/material.dart';

import '../l10n/l10n_helpers.dart';
import '../services/feed_repository.dart';
import '../services/locale_controller.dart';
import '../services/preferences_controller.dart';
import '../services/saved_controller.dart';
import 'feed_screen.dart';
import 'more_screen.dart';
import 'saved_screen.dart';

/// Bottom navigation: Feed and My deadlines.
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.repository,
    required this.saved,
    required this.locale,
    required this.prefs,
  });

  final FeedRepository repository;
  final SavedController saved;
  final LocaleController locale;
  final PreferencesController prefs;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.repository.current.addListener(_onFeed);
    _onFeed();
  }

  @override
  void dispose() {
    widget.repository.current.removeListener(_onFeed);
    super.dispose();
  }

  void _onFeed() {
    final feed = widget.repository.current.value;
    if (feed != null) widget.saved.sync(feed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          FeedScreen(
            repository: widget.repository,
            saved: widget.saved,
            locale: widget.locale,
            prefs: widget.prefs,
          ),
          SavedScreen(repository: widget.repository, saved: widget.saved),
          MoreScreen(locale: widget.locale, prefs: widget.prefs),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.saved,
        builder: (_, _) => NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore),
              label: context.l10n.navFeed,
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: widget.saved.savedIds.isNotEmpty,
                label: Text('${widget.saved.savedIds.length}'),
                child: const Icon(Icons.bookmark_border),
              ),
              selectedIcon: const Icon(Icons.bookmark),
              label: context.l10n.navMyDeadlines,
            ),
            NavigationDestination(
              icon: const Icon(Icons.more_horiz),
              label: context.l10n.navMore,
            ),
          ],
        ),
      ),
    );
  }
}
