import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../models/listing.dart';
import 'app_localizations.dart';

extension LocalizedListingType on ListingType {
  String label(AppLocalizations l) => switch (this) {
    ListingType.govtJob => l.typeGovtJob,
    ListingType.privateJob => l.typePrivateJob,
    ListingType.scholarship => l.typeScholarship,
    ListingType.internship => l.typeInternship,
  };
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Formats [date] using the app's current language, e.g. `monthDay(d)`.
  String formatDate(DateTime date, DateFormat Function(String locale) fmt) =>
      fmt(Localizations.localeOf(this).toString()).format(date);
}

/// Readable name for an `educationLevel` feed value; unknown values pass through.
String educationLabel(AppLocalizations l, String value) => switch (value) {
  'matric' => l.eduMatric,
  'inter' => l.eduInter,
  'bachelor' => l.eduBachelor,
  'master' => l.eduMaster,
  _ => value,
};
