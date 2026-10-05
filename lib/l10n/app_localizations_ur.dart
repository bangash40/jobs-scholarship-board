// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'نوکریاں اور وظائف';

  @override
  String get headerTitle => 'تصدیق شدہ مواقع';

  @override
  String openNow(int count) {
    return '$count کھلے ہیں · نوکریاں، وظائف اور انٹرن شپس';
  }

  @override
  String get searchHint => 'عنوان یا ادارہ تلاش کریں';

  @override
  String get filterAll => 'سب';

  @override
  String get filterClosingSoon => 'جلد بند ہونے والے';

  @override
  String get typeGovtJob => 'سرکاری نوکری';

  @override
  String get typePrivateJob => 'نجی نوکری';

  @override
  String get typeScholarship => 'وظیفہ';

  @override
  String get typeInternship => 'انٹرن شپ';

  @override
  String get noListings => 'کوئی اندراج نہیں ملا۔';

  @override
  String get loadError =>
      'فہرست لوڈ نہیں ہو سکی۔ دوبارہ کوشش کے لیے نیچے کھینچیں۔';

  @override
  String get offlineNotice =>
      'آف لائن — آخری محفوظ شدہ فہرست دکھائی جا رہی ہے۔';

  @override
  String lastUpdated(String date) {
    return 'آخری تازہ کاری $date';
  }

  @override
  String get navFeed => 'فیڈ';

  @override
  String get navMyDeadlines => 'میری آخری تاریخیں';

  @override
  String get savedSubtitle =>
      'محفوظ کردہ اندراجات، قریب ترین آخری تاریخ پہلے۔ بند ہونے سے 7، 2 اور 1 دن پہلے یاد دہانی کے لیے کسی اندراج پر گھنٹی دبائیں۔';

  @override
  String get savedEmpty =>
      'ابھی کچھ محفوظ نہیں۔\nآخری تاریخ پر نظر رکھنے کے لیے کسی اندراج پر بک مارک دبائیں۔';

  @override
  String get verified => 'تصدیق شدہ';

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دن باقی',
      one: '1 دن باقی',
      zero: 'آج بند ہو رہا ہے',
    );
    return '$_temp0';
  }

  @override
  String get lastDateToApply => 'درخواست کی آخری تاریخ';

  @override
  String get location => 'مقام';

  @override
  String get field => 'شعبہ';

  @override
  String get educationLevel => 'تعلیمی سطح';

  @override
  String get eligibility => 'اہلیت';

  @override
  String get description => 'تفصیل';

  @override
  String get openOfficialSource => 'سرکاری ذریعہ کھولیں';

  @override
  String get noFeesNotice =>
      'ہم کبھی فیس نہیں لیتے۔ درخواست دینے کے لیے کسی کو رقم ادا نہ کریں۔';

  @override
  String get couldNotOpenLink => 'لنک نہیں کھل سکا';

  @override
  String get tooltipReminders => 'آخری تاریخ کی یاد دہانی';

  @override
  String get tooltipSave => 'محفوظ کریں';

  @override
  String get remindersOff => 'یاد دہانیاں بند کر دی گئیں';

  @override
  String remindersSet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count یاد دہانیاں مقرر (صبح 9:00)',
      one: '1 یاد دہانی مقرر (صبح 9:00)',
    );
    return '$_temp0';
  }

  @override
  String get remindersNone =>
      'کوئی یاد دہانی مقرر نہیں ہو سکی — آخری تاریخ بہت قریب ہے';

  @override
  String get languageToggle => 'English';

  @override
  String notifClosingIn(int days) {
    return '$days دن میں بند ہو رہا ہے';
  }

  @override
  String get notifLastDay => 'کل آخری دن ہے';

  @override
  String get filtersTitle => 'فلٹرز';

  @override
  String get filterCity => 'شہر';

  @override
  String get filterAny => 'کوئی بھی';

  @override
  String get filterReset => 'ری سیٹ';

  @override
  String get filterApply => 'نتائج دکھائیں';

  @override
  String get navMore => 'مزید';

  @override
  String get moreLanguage => 'زبان';

  @override
  String get moreSafetyTitle => 'فراڈ سے محفوظ رہیں';

  @override
  String get safetyTip1 =>
      'اصل ادارے اور وظائف درخواست دینے کے لیے رقم کا مطالبہ کبھی نہیں کرتے۔';

  @override
  String get safetyTip2 =>
      'صرف ہر اندراج پر دیے گئے سرکاری لنک سے درخواست دیں۔';

  @override
  String get safetyTip3 =>
      'واٹس ایپ پر آنے والی پیشکشوں یا ایزی پیسہ/جاز کیش کے ذریعے رقم مانگنے والوں سے ہوشیار رہیں۔';

  @override
  String get safetyTip4 =>
      'درخواست سے پہلے سرکاری ویب سائٹ پر آخری تاریخ ضرور دیکھ لیں۔';

  @override
  String get moreAboutTitle => 'ہمارے بارے میں';

  @override
  String get moreAboutBody =>
      'ہر اندراج سرکاری ذریعے سے منسلک ہے اور ظاہر ہونے سے پہلے کسی شخص کی جانچ سے گزرتا ہے۔ ختم شدہ اندراجات خود بخود ہٹ جاتے ہیں۔';

  @override
  String get tooltipShare => 'واٹس ایپ پر شیئر کریں';

  @override
  String shareMessage(
    String title,
    String organization,
    String date,
    String url,
  ) {
    return '$title — $organization\nآخری تاریخ: $date\nسرکاری لنک: $url';
  }

  @override
  String get reportButton => 'مشکوک اندراج کی اطلاع دیں';

  @override
  String get reportTitle => 'آپ اس کی اطلاع کیوں دے رہے ہیں؟';

  @override
  String get reasonFee => 'فیس یا رقم مانگی جا رہی ہے';

  @override
  String get reasonFake => 'جعلی یا فراڈ لگتا ہے';

  @override
  String get reasonExpired => 'آخری تاریخ غلط یا گزر چکی ہے';

  @override
  String get reasonLink => 'لنک خراب یا غلط ہے';

  @override
  String get reasonOther => 'کوئی اور وجہ';

  @override
  String get onboardTitle => 'اپنی فیڈ اپنی پسند کے مطابق بنائیں';

  @override
  String get onboardSubtitle =>
      'اختیاری۔ وہ چنیں جو آپ کے لیے اہم ہے۔ آپ اسے کسی بھی وقت \"مزید\" میں بدل سکتے ہیں۔';

  @override
  String get onboardTypes => 'میں تلاش کر رہا/رہی ہوں';

  @override
  String get onboardCity => 'میرا شہر';

  @override
  String get onboardEducation => 'میری تعلیمی سطح';

  @override
  String get onboardContinue => 'جاری رکھیں';

  @override
  String get onboardSkip => 'ابھی چھوڑ دیں';

  @override
  String get forYou => 'آپ کے لیے';

  @override
  String get moreInterests => 'میری پسند';

  @override
  String get eduMatric => 'میٹرک';

  @override
  String get eduInter => 'انٹرمیڈیٹ';

  @override
  String get eduBachelor => 'بیچلرز';

  @override
  String get eduMaster => 'ماسٹرز';
}
