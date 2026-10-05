import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';
import '../services/saved_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/listing_card.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.listing, required this.saved});

  final Listing listing;
  final SavedController saved;

  Future<void> _toggleReminder(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    final on = !saved.hasReminder(listing.id);
    final count = await saved.setReminder(listing, on);
    final msg = !on
        ? l.remindersOff
        : count > 0
        ? l.remindersSet(count)
        : l.remindersNone;
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _share(BuildContext context) async {
    final l = context.l10n;
    final text = l.shareMessage(
      listing.title,
      listing.organization,
      context.formatDate(listing.lastDate, DateFormat.yMMMd),
      listing.sourceUrl,
    );
    final ok = await launchUrl(
      Uri.https('wa.me', '/', {'text': text}),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotOpenLink)),
      );
    }
  }

  Future<void> _openSource(BuildContext context) async {
    final ok = await launchUrl(
      Uri.parse(listing.sourceUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.couldNotOpenLink)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = listing.daysLeft(DateTime.now());
    final color = deadlineColor(days);
    final typeColor = listing.type.color;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            foregroundColor: Colors.white,
            backgroundColor: typeColor,
            actions: [
              ListenableBuilder(
                listenable: saved,
                builder: (_, _) => Row(
                  children: [
                    IconButton(
                      tooltip: context.l10n.tooltipReminders,
                      onPressed: () => _toggleReminder(context),
                      icon: Icon(
                        saved.hasReminder(listing.id)
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.tooltipShare,
                      onPressed: () => _share(context),
                      icon: const Icon(Icons.share),
                    ),
                    IconButton(
                      tooltip: context.l10n.tooltipSave,
                      onPressed: () => saved.toggleSaved(listing),
                      icon: Icon(
                        saved.isSaved(listing.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, typeColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(listing.type.icon, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            listing.type.label(context.l10n),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      listing.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.organization,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.list(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event, color: color, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.lastDateToApply,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            Text(
                              context.formatDate(listing.lastDate, DateFormat.yMMMMd),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DeadlinePill(daysLeft: days),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (listing.verified)
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: VerifiedBadge(),
                  ),
                const SizedBox(height: 12),
                _Section(
                  Icons.place_outlined,
                  context.l10n.location,
                  '${listing.city}, ${listing.province}',
                ),
                _Section(Icons.category_outlined, context.l10n.field, listing.field),
                _Section(
                  Icons.school_outlined,
                  context.l10n.educationLevel,
                  listing.educationLevel,
                ),
                _Section(
                  Icons.rule,
                  context.l10n.eligibility,
                  listing.eligibility,
                ),
                _Section(
                  Icons.description_outlined,
                  context.l10n.description,
                  listing.description,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => _openSource(context),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(context.l10n.openOfficialSource),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.verified.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.verified,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.l10n.noFeesNotice,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    if (body.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(body, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
