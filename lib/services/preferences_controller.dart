import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/listing.dart';
import 'reminder_service.dart';

/// The user's optional interests, used to build the "For you" view.
/// Stored on the device only.
class PreferencesController extends ChangeNotifier {
  PreferencesController(this._reminders);

  final ReminderService _reminders;
  late final Box<String> _box;

  Set<String> _types = {};
  String? _city;
  String? _education;
  bool _onboarded = false;
  List<int> _reminderDays = ReminderService.allDays;

  /// Main cities offered in the setup. Match the `city` values in the feed.
  static const cities = [
    'Islamabad',
    'Rawalpindi',
    'Lahore',
    'Karachi',
    'Peshawar',
    'Quetta',
    'Faisalabad',
    'Multan',
  ];

  /// Match the `educationLevel` values in the feed.
  static const educationLevels = ['matric', 'inter', 'bachelor', 'master'];

  Set<String> get types => _types;
  String? get city => _city;
  String? get education => _education;
  bool get onboarded => _onboarded;
  List<int> get reminderDays => _reminderDays;
  bool get hasInterests =>
      _types.isNotEmpty || _city != null || _education != null;

  Future<void> init() async {
    _box = await Hive.openBox<String>('settings');
    _onboarded = _box.get('onboarded') == 'true';
    final types = _box.get('interestTypes') ?? '';
    _types = types.isEmpty ? {} : types.split(',').toSet();
    _city = _nonEmpty(_box.get('interestCity'));
    _education = _nonEmpty(_box.get('interestEducation'));
    final days = (_box.get('reminderDays') ?? '')
        .split(',')
        .map(int.tryParse)
        .whereType<int>()
        .where(ReminderService.allDays.contains)
        .toList();
    _reminderDays = days.isEmpty ? ReminderService.allDays : days;
    _reminders.activeDays = _reminderDays;
  }

  /// Chooses which days before the deadline to alert at. At least one stays on.
  Future<void> setReminderDays(Iterable<int> days) async {
    final chosen = ReminderService.allDays.where(days.contains).toList();
    if (chosen.isEmpty) return;
    _reminderDays = chosen;
    _reminders.activeDays = chosen;
    await _box.put('reminderDays', chosen.join(','));
    notifyListeners();
  }

  String? _nonEmpty(String? v) => (v == null || v.isEmpty) ? null : v;

  /// Saves the choices and marks setup as done (also used when skipping).
  Future<void> save({
    Set<String> types = const {},
    String? city,
    String? education,
  }) async {
    _types = {...types};
    _city = city;
    _education = education;
    _onboarded = true;
    await _box.putAll({
      'onboarded': 'true',
      'interestTypes': _types.join(','),
      'interestCity': city ?? '',
      'interestEducation': education ?? '',
    });
    notifyListeners();
  }

  /// A listing with no city / education set (e.g. nationwide) is never excluded
  /// by those choices.
  bool matches(Listing l) {
    if (_types.isNotEmpty && !_types.contains(l.type.key)) return false;
    if (_city != null && l.city.isNotEmpty && l.city != _city) return false;
    if (_education != null &&
        l.educationLevel.isNotEmpty &&
        l.educationLevel != _education) {
      return false;
    }
    return true;
  }
}
