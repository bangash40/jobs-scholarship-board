import 'package:flutter/material.dart';

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
                    const Text(
                      'My deadlines',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Saved listings, soonest first. Tap the bell on a '
                      'listing to get alerts 7, 2 and 1 days before it closes.',
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
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_add_outlined,
                            size: 48,
                            color: AppColors.muted,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Nothing saved yet.\nTap the bookmark on any '
                            'listing to track its deadline.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.muted),
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
