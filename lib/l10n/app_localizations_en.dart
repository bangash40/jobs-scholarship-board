// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Jobs & Scholarships';

  @override
  String get headerTitle => 'Verified Opportunities';

  @override
  String openNow(int count) {
    return '$count open now · Jobs, scholarships & internships';
  }

  @override
  String get searchHint => 'Search title or organization';

  @override
  String get filterAll => 'All';

  @override
  String get filterClosingSoon => 'Closing soon';

  @override
  String get typeGovtJob => 'Govt job';

  @override
  String get typePrivateJob => 'Private job';

  @override
  String get typeScholarship => 'Scholarship';

  @override
  String get typeInternship => 'Internship';

  @override
  String get noListings => 'No listings match.';

  @override
  String get loadError => 'Could not load listings. Pull down to retry.';

  @override
  String get offlineNotice => 'Offline — showing last synced listings.';

  @override
  String lastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get navFeed => 'Feed';

  @override
  String get navMyDeadlines => 'My deadlines';

  @override
  String get savedSubtitle =>
      'Saved listings, soonest first. Tap the bell on a listing to get alerts 7, 2 and 1 days before it closes.';

  @override
  String get savedEmpty =>
      'Nothing saved yet.\nTap the bookmark on any listing to track its deadline.';

  @override
  String get verified => 'Verified';

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Closes today',
    );
    return '$_temp0';
  }

  @override
  String get lastDateToApply => 'Last date to apply';

  @override
  String get location => 'Location';

  @override
  String get field => 'Field';

  @override
  String get educationLevel => 'Education level';

  @override
  String get eligibility => 'Eligibility';

  @override
  String get description => 'Description';

  @override
  String get openOfficialSource => 'Open official source';

  @override
  String get noFeesNotice => 'We never charge fees. Never pay anyone to apply.';

  @override
  String get couldNotOpenLink => 'Could not open the link';

  @override
  String get tooltipReminders => 'Deadline reminders';

  @override
  String get tooltipSave => 'Save';

  @override
  String get remindersOff => 'Reminders turned off';

  @override
  String remindersSet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders set (9:00 am)',
      one: '1 reminder set (9:00 am)',
    );
    return '$_temp0';
  }

  @override
  String get remindersNone => 'No reminders to set — the deadline is too close';

  @override
  String get languageToggle => 'اردو';

  @override
  String notifClosingIn(int days) {
    return 'Closing in $days days';
  }

  @override
  String get notifLastDay => 'Last day tomorrow';
}
