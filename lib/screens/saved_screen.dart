import 'package:flutter/material.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';
import '../services/feed_repository.dart';
import '../services/saved_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';
import 'detail_screen.dart';

/// Saved listings sorted by nearest deadline.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.repository, required this.saved});

  final FeedRepository repository;
  final SavedController saved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.navMyDeadlines,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.savedSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge([saved, repository.current]),
              builder: (context, _) {
                final feed = repository.current.value;
                final now = DateTime.now();
                final ids = saved.savedIds;
                final items = (feed?.listings ?? const <Listing>[])
                    .where((l) => ids.contains(l.id) && !l.isExpired(now))
                    .toList()
                  ..sort((a, b) => a.lastDate.compareTo(b.lastDate));
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bookmark_add_outlined,
                            size: 48,
                            color: AppColors.muted,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.savedEmpty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: items.length,
                  itemBuilder: (_, i) => ListingCard(
                    listing: items[i],
                    saved: saved,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            DetailScreen(listing: items[i], saved: saved),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
