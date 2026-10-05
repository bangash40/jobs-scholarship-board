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

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filterCity => 'City';

  @override
  String get filterAny => 'Any';

  @override
  String get filterReset => 'Reset';

  @override
  String get filterApply => 'Show results';

  @override
  String get navMore => 'More';

  @override
  String get moreLanguage => 'Language';

  @override
  String get moreSafetyTitle => 'Stay safe from scams';

  @override
  String get safetyTip1 =>
      'Genuine employers and scholarships never ask you to pay to apply.';

  @override
  String get safetyTip2 =>
      'Apply only through the official link shown on each listing.';

  @override
  String get safetyTip3 =>
      'Be careful of offers that arrive on WhatsApp or ask for money via EasyPaisa or JazzCash.';

  @override
  String get safetyTip4 =>
      'Always check the last date on the official website before applying.';

  @override
  String get moreAboutTitle => 'About';

  @override
  String get moreAboutBody =>
      'Every listing links to an official source and is checked by a person before it appears. Expired listings are removed automatically.';

  @override
  String get tooltipShare => 'Share on WhatsApp';

  @override
  String shareMessage(
    String title,
    String organization,
    String date,
    String url,
  ) {
    return '$title — $organization\nLast date: $date\nOfficial link: $url';
  }

  @override
  String get reportButton => 'Report suspicious listing';

  @override
  String get reportTitle => 'Why are you reporting this?';

  @override
  String get reasonFee => 'Asks for a fee or payment';

  @override
  String get reasonFake => 'Looks fake or a scam';

  @override
  String get reasonExpired => 'Deadline is wrong or expired';

  @override
  String get reasonLink => 'Link is broken or wrong';

  @override
  String get reasonOther => 'Something else';

  @override
  String get onboardTitle => 'Personalise your feed';

  @override
  String get onboardSubtitle =>
      'Optional. Pick what matters to you. You can change this anytime in More.';

  @override
  String get onboardTypes => 'I\'m looking for';

  @override
  String get onboardCity => 'My city';

  @override
  String get onboardEducation => 'My education level';

  @override
  String get onboardContinue => 'Continue';

  @override
  String get onboardSkip => 'Skip for now';

  @override
  String get forYou => 'For you';

  @override
  String get moreInterests => 'My interests';

  @override
  String get eduMatric => 'Matric';

  @override
  String get eduInter => 'Intermediate';

  @override
  String get eduBachelor => 'Bachelor\'s';

  @override
  String get eduMaster => 'Master\'s';
}
