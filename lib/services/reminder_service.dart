import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/listing.dart';

/// Schedules on-device deadline alerts (no server needed).
class ReminderService {
  /// Every day-offset the app can alert at. Notification ids are derived from
  /// a day's position here, so this list must never be reordered.
  static const allDays = [7, 2, 1];

  /// The days the user has chosen to be alerted at (a subset of [allDays]).
  List<int> activeDays = allDays;

  /// Local time of day the alerts fire.
  static const _alertHour = 9;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Builds the notification title for an alert [days] before closing.
  /// Set by LocaleController so alerts follow the app language.
  String Function(int days) titleFor = (days) =>
      days == 1 ? 'Last day tomorrow' : 'Closing in $days days';

  bool get supported => defaultTargetPlatform == TargetPlatform.android;

  Future<void> init() async {
    if (!supported) return;
    tzdata.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Asks for the Android 13+ notification permission. Returns true if granted.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? false;
  }

  int _id(String listingId, int index) =>
      (listingId.hashCode.abs() % 100000000) * allDays.length + index;

  /// Dates the alerts would fire for [l], skipping any already in the past.
  List<(int index, tz.TZDateTime at)> upcoming(Listing l) {
    final now = tz.TZDateTime.now(tz.local);
    final out = <(int, tz.TZDateTime)>[];
    for (final days in activeDays) {
      final day = l.lastDate.subtract(Duration(days: days));
      final when = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        _alertHour,
      );
      if (when.isAfter(now)) out.add((allDays.indexOf(days), when));
    }
    return out;
  }

  /// Replaces any existing alerts for [l]. Returns how many were scheduled.
  Future<int> schedule(Listing l) async {
    if (!_ready) return 0;
    await cancel(l);
    final times = upcoming(l);
    for (final (i, at) in times) {
      final days = allDays[i];
      await _plugin.zonedSchedule(
        id: _id(l.id, i),
        title: titleFor(days),
        body: '${l.title} · ${l.organization}',
        scheduledDate: at,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'deadlines',
            'Deadline reminders',
            channelDescription: 'Alerts before saved listings close',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
    return times.length;
  }

  Future<void> cancel(Listing l) => cancelById(l.id);

  Future<void> cancelById(String listingId) async {
    if (!_ready) return;
    for (var i = 0; i < allDays.length; i++) {
      await _plugin.cancel(id: _id(listingId, i));
    }
  }
}
