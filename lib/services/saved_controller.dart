import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/listing.dart';
import 'reminder_service.dart';

/// Bookmarks and reminder state, stored on-device only (Hive).
/// The box maps listing id -> whether deadline reminders are on.
class SavedController extends ChangeNotifier {
  SavedController(this.reminders);

  final ReminderService reminders;
  late final Box<bool> _box;

  Future<void> init() async {
    _box = await Hive.openBox<bool>('saved');
  }

  bool isSaved(String id) => _box.containsKey(id);
  bool hasReminder(String id) => _box.get(id) ?? false;
  Set<String> get savedIds => _box.keys.cast<String>().toSet();

  Future<void> toggleSaved(Listing l) async {
    if (isSaved(l.id)) {
      await reminders.cancel(l);
      await _box.delete(l.id);
    } else {
      await _box.put(l.id, false);
    }
    notifyListeners();
  }

  /// Turns reminders on/off for [l] (saving it if needed).
  /// Returns the number of alerts scheduled when turning on.
  Future<int> setReminder(Listing l, bool on) async {
    var scheduled = 0;
    if (on) {
      await reminders.requestPermission();
      scheduled = await reminders.schedule(l);
    } else {
      await reminders.cancel(l);
    }
    await _box.put(l.id, on);
    notifyListeners();
    return scheduled;
  }

  /// Reconciles alerts with a freshly synced feed: reschedules in case dates
  /// changed, and drops saved items whose listing was pulled or has expired.
  Future<void> sync(Feed feed) async {
    final byId = {for (final l in feed.listings) l.id: l};
    final now = DateTime.now();
    for (final id in savedIds) {
      final l = byId[id];
      if (l == null) {
        // Pulled from the feed: drop it and its alerts.
        await reminders.cancelById(id);
        await _box.delete(id);
      } else if (l.isExpired(now)) {
        await reminders.cancel(l);
        await _box.delete(id);
      } else if (hasReminder(id)) {
        await reminders.schedule(l);
      }
    }
    notifyListeners();
  }
}
