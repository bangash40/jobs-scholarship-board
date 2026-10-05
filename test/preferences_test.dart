import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobs_scholarship_board/models/listing.dart';
import 'package:jobs_scholarship_board/services/preferences_controller.dart';
import 'package:jobs_scholarship_board/services/reminder_service.dart';

Listing _l({String type = 'govt_job', String city = '', String edu = ''}) =>
    Listing.fromJson({
      'id': 'x',
      'type': type,
      'title': 't',
      'sourceUrl': 'https://example.com',
      'lastDate': '2026-12-01T00:00:00Z',
      'postedAt': '2026-10-01T00:00:00Z',
      'city': city,
      'educationLevel': edu,
    });

void main() {
  late PreferencesController prefs;

  setUp(() async {
    Hive.init(Directory.systemTemp.createTempSync('prefs_test').path);
    prefs = PreferencesController(ReminderService());
    await prefs.init();
  });

  tearDown(() async => Hive.close());

  test('starts not onboarded with no interests', () {
    expect(prefs.onboarded, isFalse);
    expect(prefs.hasInterests, isFalse);
    expect(prefs.matches(_l()), isTrue);
  });

  test('skipping marks onboarded without interests', () async {
    await prefs.save();
    expect(prefs.onboarded, isTrue);
    expect(prefs.hasInterests, isFalse);
  });

  test('matches by type, and city/education only when the listing sets them', () async {
    await prefs.save(types: {'scholarship'}, city: 'Lahore', education: 'master');
    expect(prefs.matches(_l(type: 'govt_job')), isFalse);
    expect(prefs.matches(_l(type: 'scholarship')), isTrue); // no city/edu: kept
    expect(prefs.matches(_l(type: 'scholarship', city: 'Karachi')), isFalse);
    expect(prefs.matches(_l(type: 'scholarship', city: 'Lahore', edu: 'bachelor')), isFalse);
    expect(prefs.matches(_l(type: 'scholarship', city: 'Lahore', edu: 'master')), isTrue);
  });

  test('choices survive a restart', () async {
    await prefs.save(types: {'internship'}, city: 'Quetta');
    final again = PreferencesController(ReminderService());
    await again.init();
    expect(again.onboarded, isTrue);
    expect(again.types, {'internship'});
    expect(again.city, 'Quetta');
    expect(again.education, isNull);
  });

  test('reminder days default to all and keep at least one', () async {
    expect(prefs.reminderDays, [7, 2, 1]);
    await prefs.setReminderDays([2]);
    expect(prefs.reminderDays, [2]);
    await prefs.setReminderDays([]); // ignored: one must stay on
    expect(prefs.reminderDays, [2]);
    await prefs.setReminderDays([1, 7]);
    expect(prefs.reminderDays, [7, 1]); // kept in canonical order
  });

  test('reminder days survive a restart and reach the reminder service', () async {
    await prefs.setReminderDays([7, 1]);
    final reminders = ReminderService();
    final again = PreferencesController(reminders);
    await again.init();
    expect(again.reminderDays, [7, 1]);
    expect(reminders.activeDays, [7, 1]);
  });
}
