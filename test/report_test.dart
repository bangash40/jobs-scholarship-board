import 'package:flutter_test/flutter_test.dart';
import 'package:jobs_scholarship_board/models/listing.dart';
import 'package:jobs_scholarship_board/services/report_service.dart';

final _listing = Listing.fromJson({
  'id': 'hec-1',
  'type': 'scholarship',
  'title': 'Need Based & Merit',
  'organization': 'HEC',
  'sourceUrl': 'https://www.hec.gov.pk/x',
  'lastDate': '2026-12-01T00:00:00Z',
  'postedAt': '2026-10-01T00:00:00Z',
});

void main() {
  test('uses a mailto link when an email is configured', () {
    final uri = reportUri(_listing, ReportReason.fake, email: 'a@b.com');
    expect(uri.scheme, 'mailto');
    expect(uri.path, 'a@b.com');
    expect(uri.query, contains('subject=Report%3A%20Need%20Based%20%26%20Merit'));
    expect(uri.query, isNot(contains('+')));
  });

  test('falls back to a GitHub issue when no email is set', () {
    final uri = reportUri(_listing, ReportReason.fee, email: '');
    expect(uri.host, 'github.com');
    expect(uri.queryParameters['title'], 'Report: Need Based & Merit');
    final body = uri.queryParameters['body']!;
    expect(body, contains('Listing ID: hec-1'));
    expect(body, contains('Reason: Asks for a fee or payment'));
    expect(body, contains('https://www.hec.gov.pk/x'));
  });
}
