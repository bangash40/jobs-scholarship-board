import 'package:flutter_test/flutter_test.dart';
import 'package:jobs_scholarship_board/models/listing.dart';

Listing _listing(String lastDate) => Listing.fromJson({
  'id': 'x',
  'type': 'scholarship',
  'title': 't',
  'sourceUrl': 'https://example.com',
  'lastDate': lastDate,
  'postedAt': '2026-10-01T00:00:00Z',
});

void main() {
  test('daysLeft counts calendar days', () {
    final l = _listing('2026-10-09T12:00:00');
    expect(l.daysLeft(DateTime(2026, 10, 5, 23)), 4);
    expect(l.daysLeft(DateTime(2026, 10, 9)), 0);
  });

  test('isExpired only after the last date has passed', () {
    final l = _listing('2026-10-09T12:00:00');
    expect(l.isExpired(DateTime(2026, 10, 9, 20)), isFalse);
    expect(l.isExpired(DateTime(2026, 10, 10)), isTrue);
  });

  test('unknown type falls back to private job', () {
    expect(ListingType.fromKey('nonsense'), ListingType.privateJob);
  });
}
