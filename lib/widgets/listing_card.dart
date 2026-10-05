import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';
import '../services/saved_controller.dart';
import '../theme/app_theme.dart';

Color deadlineColor(int daysLeft) {
  if (daysLeft <= 2) return AppColors.urgent;
  if (daysLeft <= 7) return AppColors.soon;
  return AppColors.comfortable;
}

/// Coloured pill, e.g. "Scholarship", tinted by listing type.
class TypeChip extends StatelessWidget {
  const TypeChip(this.type, {super.key});
  final ListingType type;

  @override
  Widget build(BuildContext context) {
    final c = type.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 13, color: c),
          const SizedBox(width: 4),
          Text(
            type.label(context.l10n),
            style: TextStyle(
              color: c,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.verified, size: 15, color: AppColors.verified),
      const SizedBox(width: 3),
      Text(
        context.l10n.verified,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.verified,
        ),
      ),
    ],
  );
}

class DeadlinePill extends StatelessWidget {
  const DeadlinePill({super.key, required this.daysLeft});
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final c = deadlineColor(daysLeft);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 14, color: c),
          const SizedBox(width: 4),
          Text(
            context.l10n.daysLeft(daysLeft),
            style: TextStyle(
              color: c,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    required this.saved,
  });

  final Listing listing;
  final VoidCallback onTap;
  final SavedController saved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = listing.daysLeft(DateTime.now());
    final typeColor = listing.type.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Type-coloured accent edge.
                Container(width: 5, color: typeColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TypeChip(listing.type),
                            const SizedBox(width: 8),
                            if (listing.verified) const VerifiedBadge(),
                            const Spacer(),
                            ListenableBuilder(
                              listenable: saved,
                              builder: (_, _) {
                                final isSaved = saved.isSaved(listing.id);
                                return InkResponse(
                                  radius: 20,
                                  onTap: () => saved.toggleSaved(listing),
                                  child: Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isSaved
                                        ? AppColors.primary
                                        : AppColors.muted,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(listing.title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(
                          listing.organization,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              size: 16,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                listing.city,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.muted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              context.formatDate(listing.lastDate, DateFormat.MMMd),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(width: 8),
                            DeadlinePill(daysLeft: days),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
