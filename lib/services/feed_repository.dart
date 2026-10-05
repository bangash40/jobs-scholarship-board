import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/listing.dart';

/// Where the scraper publishes feed.json (GitHub Pages, Firebase Hosting, ...).
/// Leave empty to use only the bundled sample feed.
const String kFeedUrl = '';

/// Loads the feed: cached copy first, then network, falling back to the
/// bundled sample so the app always has something to show.
class FeedRepository {
  static const _boxName = 'feed_cache';
  static const _key = 'feed_json';

  late final Box<String> _box;

  /// Latest feed (cached, then fresh). Other screens listen to this.
  final ValueNotifier<Feed?> current = ValueNotifier<Feed?>(null);

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
    current.value = loadCached();
  }

  /// Last successfully synced feed, or null on first launch.
  Feed? loadCached() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    try {
      return Feed.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Fetches a fresh feed and caches it. Throws if it can't be loaded.
  Future<Feed> refresh() async {
    final String raw;
    if (kFeedUrl.isEmpty) {
      raw = await rootBundle.loadString('assets/feed.json');
    } else {
      final res = await http
          .get(Uri.parse(kFeedUrl))
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        throw Exception('Feed request failed (${res.statusCode})');
      }
      raw = utf8.decode(res.bodyBytes);
    }
    final feed = Feed.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    await _box.put(_key, raw);
    current.value = feed;
    return feed;
  }
}
