import 'package:flutter/material.dart';

import '../l10n/l10n_helpers.dart';
import '../models/listing.dart';

/// Detail filters chosen in the sheet. Null means "any".
class FeedFilters {
  const FeedFilters({this.city, this.educationLevel, this.field});

  final String? city;
  final String? educationLevel;
  final String? field;

  static const none = FeedFilters();

  int get activeCount =>
      [city, educationLevel, field].where((v) => v != null).length;

  bool matches(Listing l) =>
      (city == null || l.city == city) &&
      (educationLevel == null || l.educationLevel == educationLevel) &&
      (field == null || l.field == field);
}

/// Distinct non-empty values for a listing property, sorted.
List<String> _options(List<Listing> all, String Function(Listing) pick) =>
    (all.map(pick).where((v) => v.isNotEmpty).toSet().toList()..sort());

Future<FeedFilters?> showFilterSheet(
  BuildContext context, {
  required List<Listing> listings,
  required FeedFilters current,
}) {
  return showModalBottomSheet<FeedFilters>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FilterSheet(listings: listings, current: current),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.listings, required this.current});

  final List<Listing> listings;
  final FeedFilters current;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _city = widget.current.city;
  late String? _education = widget.current.educationLevel;
  late String? _field = widget.current.field;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  l.filtersTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() {
                    _city = null;
                    _education = null;
                    _field = null;
                  }),
                  child: Text(l.filterReset),
                ),
              ],
            ),
            _group(
              l.filterCity,
              _options(widget.listings, (x) => x.city),
              _city,
              (v) => setState(() => _city = v),
            ),
            _group(
              l.educationLevel,
              _options(widget.listings, (x) => x.educationLevel),
              _education,
              (v) => setState(() => _education = v),
            ),
            _group(
              l.field,
              _options(widget.listings, (x) => x.field),
              _field,
              (v) => setState(() => _field = v),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                FeedFilters(
                  city: _city,
                  educationLevel: _education,
                  field: _field,
                ),
              ),
              child: Text(l.filterApply),
            ),
          ],
        ),
      ),
    );
  }

  Widget _group(
    String title,
    List<String> options,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    if (options.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                label: Text(context.l10n.filterAny),
                selected: selected == null,
                onSelected: (_) => onChanged(null),
              ),
              for (final o in options)
                ChoiceChip(
                  label: Text(o),
                  selected: selected == o,
                  onSelected: (_) => onChanged(o),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
