import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n_helpers.dart';
import '../services/report_service.dart';

String _label(AppLocalizations l, ReportReason r) => switch (r) {
  ReportReason.fee => l.reasonFee,
  ReportReason.fake => l.reasonFake,
  ReportReason.expired => l.reasonExpired,
  ReportReason.link => l.reasonLink,
  ReportReason.other => l.reasonOther,
};

/// Lets the user pick why a listing looks wrong. Returns null if dismissed.
Future<ReportReason?> showReportSheet(BuildContext context) {
  return showModalBottomSheet<ReportReason>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final l = context.l10n;
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                l.reportTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final r in ReportReason.values)
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(_label(l, r)),
                onTap: () => Navigator.of(context).pop(r),
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
