import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';
import '../services/feed_repository.dart';
import '../services/locale_controller.dart';
import '../services/saved_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';
import 'detail_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.repository,
    required this.saved,
    required this.locale,
  });

  final FeedRepository repository;
  final SavedController saved;
  final LocaleController locale;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  static const _closingSoonDays = 7;

  Feed? _feed;
  bool _loading = true;
  bool _failed = false;
  ListingType? _type;
  bool _closingSoon = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _feed = widget.repository.loadCached();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final feed = await widget.repository.refresh();
      if (!mounted) return;
      setState(() => _feed = feed);
    } catch (e) {
      if (!mounted) return;
      setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Listing> get _visible {
    final now = DateTime.now();
    final q = _query.trim().toLowerCase();
    final items = (_feed?.listings ?? const <Listing>[]).where((l) {
      if (l.isExpired(now)) return false;
      if (_type != null && l.type != _type) return false;
      if (_closingSoon && l.daysLeft(now) > _closingSoonDays) return false;
      if (q.isNotEmpty &&
          !l.title.toLowerCase().contains(q) &&
          !l.organization.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
    // Soonest deadline first.
    items.sort((a, b) => a.lastDate.compareTo(b.lastDate));
    return items;
  }

  int get _openCount {
    final now = DateTime.now();
    return (_feed?.listings ?? const <Listing>[])
        .where((l) => !l.isExpired(now))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = _visible;
    final updated = _feed?.updatedAt;
    return Scaffold(
      body: Column(
        children: [
          _Header(
            openCount: _openCount,
            loading: _loading,
            onQuery: (v) => setState(() => _query = v),
            onToggleLanguage: widget.locale.toggle,
          ),
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _chip(l.filterAll, null, _type == null, () => setState(() => _type = null)),
                for (final t in ListingType.values)
                  _chip(t.label(l), t, _type == t, () => setState(() => _type = t)),
                _chip(
                  l.filterClosingSoon,
                  null,
                  _closingSoon,
                  () => setState(() => _closingSoon = !_closingSoon),
                  icon: Icons.local_fire_department,
                  color: AppColors.urgent,
                ),
              ],
            ),
          ),
          if (_failed)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.soon.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _feed == null ? l.loadError : l.offlineNotice,
                style: const TextStyle(
                  color: AppColors.soon,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: items.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: AppColors.muted.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            _loading ? '' : l.noListings,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: items.length,
                      itemBuilder: (_, i) => ListingCard(
                        listing: items[i],
                        saved: widget.saved,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetailScreen(
                              listing: items[i],
                              saved: widget.saved,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (updated != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  l.lastUpdated(
                    context.formatDate(updated, (loc) => DateFormat.yMMMd(loc).add_Hm()),
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    String label,
    ListingType? type,
    bool selected,
    VoidCallback onTap, {
    IconData? icon,
    Color? color,
  }) {
    final c = color ?? type?.color ?? AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: FilterChip(
          avatar: (icon ?? type?.icon) == null
              ? null
              : Icon(
                  icon ?? type!.icon,
                  size: 16,
                  color: selected ? Colors.white : c,
                ),
          label: Text(label),
          labelStyle: TextStyle(
            color: selected ? Colors.white : null,
            fontWeight: FontWeight.w600,
          ),
          selected: selected,
          selectedColor: c,
          onSelected: (_) => onTap(),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.openCount,
    required this.loading,
    required this.onQuery,
    required this.onToggleLanguage,
  });

  final int openCount;
  final bool loading;
  final ValueChanged<String> onQuery;
  final VoidCallback onToggleLanguage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.headerTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (loading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  TextButton(
                    onPressed: onToggleLanguage,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 34),
                    ),
                    child: Text(
                      l.languageToggle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l.openNow(openCount),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: onQuery,
                decoration: InputDecoration(
                  hintText: l.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
