import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../l10n/app_localizations.dart';
import 'reminder_service.dart';

/// Current UI language (English / Urdu), remembered across launches.
class LocaleController extends ChangeNotifier {
  LocaleController(this._reminders);

  final ReminderService _reminders;
  late final Box<String> _box;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isUrdu => _locale.languageCode == 'ur';

  Future<void> init() async {
    _box = await Hive.openBox<String>('settings');
    final saved = _box.get('locale');
    final device = PlatformDispatcher.instance.locale.languageCode;
    _locale = Locale(saved ?? (device == 'ur' ? 'ur' : 'en'));
    _applyToReminders();
  }

  Future<void> toggle() async {
    _locale = Locale(isUrdu ? 'en' : 'ur');
    await _box.put('locale', _locale.languageCode);
    _applyToReminders();
    notifyListeners();
  }

  /// Notifications are scheduled outside the widget tree, so they need their
  /// strings handed over whenever the language changes.
  void _applyToReminders() {
    final l = lookupAppLocalizations(_locale);
    _reminders.titleFor = (days) =>
        days == 1 ? l.notifLastDay : l.notifClosingIn(days);
  }
}
