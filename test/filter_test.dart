import 'package:flutter_test/flutter_test.dart';
import 'package:jobs_scholarship_board/models/listing.dart';
import 'package:jobs_scholarship_board/widgets/filter_sheet.dart';

Listing _l({String city = '', String edu = '', String field = ''}) =>
    Listing.fromJson({
      'id': 'x',
      'type': 'govt_job',
      'title': 't',
      'sourceUrl': 'https://example.com',
      'lastDate': '2026-12-01T00:00:00Z',
      'postedAt': '2026-10-01T00:00:00Z',
      'city': city,
      'educationLevel': edu,
      'field': field,
    });

void main() {
  test('no filters matches everything', () {
    expect(FeedFilters.none.matches(_l(city: 'Lahore')), isTrue);
    expect(FeedFilters.none.activeCount, 0);
  });

  test('all chosen filters must match', () {
    const f = FeedFilters(city: 'Lahore', educationLevel: 'master');
    expect(f.activeCount, 2);
    expect(f.matches(_l(city: 'Lahore', edu: 'master')), isTrue);
    expect(f.matches(_l(city: 'Lahore', edu: 'bachelor')), isFalse);
    expect(f.matches(_l(city: 'Karachi', edu: 'master')), isFalse);
  });
}
