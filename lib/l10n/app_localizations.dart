import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Jobs & Scholarships'**
  String get appTitle;

  /// No description provided for @headerTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified Opportunities'**
  String get headerTitle;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'{count} open now · Jobs, scholarships & internships'**
  String openNow(int count);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title or organization'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterClosingSoon.
  ///
  /// In en, this message translates to:
  /// **'Closing soon'**
  String get filterClosingSoon;

  /// No description provided for @typeGovtJob.
  ///
  /// In en, this message translates to:
  /// **'Govt job'**
  String get typeGovtJob;

  /// No description provided for @typePrivateJob.
  ///
  /// In en, this message translates to:
  /// **'Private job'**
  String get typePrivateJob;

  /// No description provided for @typeScholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarship'**
  String get typeScholarship;

  /// No description provided for @typeInternship.
  ///
  /// In en, this message translates to:
  /// **'Internship'**
  String get typeInternship;

  /// No description provided for @noListings.
  ///
  /// In en, this message translates to:
  /// **'No listings match.'**
  String get noListings;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load listings. Pull down to retry.'**
  String get loadError;

  /// No description provided for @offlineNotice.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing last synced listings.'**
  String get offlineNotice;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String lastUpdated(String date);

  /// No description provided for @navFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get navFeed;

  /// No description provided for @navMyDeadlines.
  ///
  /// In en, this message translates to:
  /// **'My deadlines'**
  String get navMyDeadlines;

  /// No description provided for @savedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved listings, soonest first. Tap the bell on a listing to get alerts 7, 2 and 1 days before it closes.'**
  String get savedSubtitle;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet.\nTap the bookmark on any listing to track its deadline.'**
  String get savedEmpty;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Closes today} =1{1 day left} other{{count} days left}}'**
  String daysLeft(int count);

  /// No description provided for @lastDateToApply.
  ///
  /// In en, this message translates to:
  /// **'Last date to apply'**
  String get lastDateToApply;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @educationLevel.
  ///
  /// In en, this message translates to:
  /// **'Education level'**
  String get educationLevel;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibility;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @openOfficialSource.
  ///
  /// In en, this message translates to:
  /// **'Open official source'**
  String get openOfficialSource;

  /// No description provided for @noFeesNotice.
  ///
  /// In en, this message translates to:
  /// **'We never charge fees. Never pay anyone to apply.'**
  String get noFeesNotice;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get couldNotOpenLink;

  /// No description provided for @tooltipReminders.
  ///
  /// In en, this message translates to:
  /// **'Deadline reminders'**
  String get tooltipReminders;

  /// No description provided for @tooltipSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tooltipSave;

  /// No description provided for @remindersOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders turned off'**
  String get remindersOff;

  /// No description provided for @remindersSet.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reminder set (9:00 am)} other{{count} reminders set (9:00 am)}}'**
  String remindersSet(int count);

  /// No description provided for @remindersNone.
  ///
  /// In en, this message translates to:
  /// **'No reminders to set — the deadline is too close'**
  String get remindersNone;

  /// No description provided for @languageToggle.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageToggle;

  /// No description provided for @notifClosingIn.
  ///
  /// In en, this message translates to:
  /// **'Closing in {days} days'**
  String notifClosingIn(int days);

  /// No description provided for @notifLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last day tomorrow'**
  String get notifLastDay;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filterCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filterCity;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get filterApply;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @moreLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get moreLanguage;

  /// No description provided for @moreSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay safe from scams'**
  String get moreSafetyTitle;

  /// No description provided for @safetyTip1.
  ///
  /// In en, this message translates to:
  /// **'Genuine employers and scholarships never ask you to pay to apply.'**
  String get safetyTip1;

  /// No description provided for @safetyTip2.
  ///
  /// In en, this message translates to:
  /// **'Apply only through the official link shown on each listing.'**
  String get safetyTip2;

  /// No description provided for @safetyTip3.
  ///
  /// In en, this message translates to:
  /// **'Be careful of offers that arrive on WhatsApp or ask for money via EasyPaisa or JazzCash.'**
  String get safetyTip3;

  /// No description provided for @safetyTip4.
  ///
  /// In en, this message translates to:
  /// **'Always check the last date on the official website before applying.'**
  String get safetyTip4;

  /// No description provided for @moreAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAboutTitle;

  /// No description provided for @moreAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Every listing links to an official source and is checked by a person before it appears. Expired listings are removed automatically.'**
  String get moreAboutBody;

  /// No description provided for @tooltipShare.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get tooltipShare;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'{title} — {organization}\nLast date: {date}\nOfficial link: {url}'**
  String shareMessage(
    String title,
    String organization,
    String date,
    String url,
  );

  /// No description provided for @reportButton.
  ///
  /// In en, this message translates to:
  /// **'Report suspicious listing'**
  String get reportButton;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this?'**
  String get reportTitle;

  /// No description provided for @reasonFee.
  ///
  /// In en, this message translates to:
  /// **'Asks for a fee or payment'**
  String get reasonFee;

  /// No description provided for @reasonFake.
  ///
  /// In en, this message translates to:
  /// **'Looks fake or a scam'**
  String get reasonFake;

  /// No description provided for @reasonExpired.
  ///
  /// In en, this message translates to:
  /// **'Deadline is wrong or expired'**
  String get reasonExpired;

  /// No description provided for @reasonLink.
  ///
  /// In en, this message translates to:
  /// **'Link is broken or wrong'**
  String get reasonLink;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reasonOther;

  /// No description provided for @onboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalise your feed'**
  String get onboardTitle;

  /// No description provided for @onboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. Pick what matters to you. You can change this anytime in More.'**
  String get onboardSubtitle;

  /// No description provided for @onboardTypes.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for'**
  String get onboardTypes;

  /// No description provided for @onboardCity.
  ///
  /// In en, this message translates to:
  /// **'My city'**
  String get onboardCity;

  /// No description provided for @onboardEducation.
  ///
  /// In en, this message translates to:
  /// **'My education level'**
  String get onboardEducation;

  /// No description provided for @onboardContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardContinue;

  /// No description provided for @onboardSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardSkip;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get forYou;

  /// No description provided for @moreInterests.
  ///
  /// In en, this message translates to:
  /// **'My interests'**
  String get moreInterests;

  /// No description provided for @eduMatric.
  ///
  /// In en, this message translates to:
  /// **'Matric'**
  String get eduMatric;

  /// No description provided for @eduInter.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get eduInter;

  /// No description provided for @eduBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor\'s'**
  String get eduBachelor;

  /// No description provided for @eduMaster.
  ///
  /// In en, this message translates to:
  /// **'Master\'s'**
  String get eduMaster;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
