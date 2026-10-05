enum ListingType {
  govtJob('govt_job', 'Govt job'),
  privateJob('private_job', 'Private job'),
  scholarship('scholarship', 'Scholarship'),
  internship('internship', 'Internship');

  const ListingType(this.key, this.label);
  final String key;
  final String label;

  static ListingType fromKey(String key) => ListingType.values.firstWhere(
    (t) => t.key == key,
    orElse: () => ListingType.privateJob,
  );
}

class Listing {
  const Listing({
    required this.id,
    required this.type,
    required this.title,
    required this.organization,
    required this.description,
    required this.eligibility,
    required this.city,
    required this.province,
    required this.field,
    required this.educationLevel,
    required this.lastDate,
    required this.postedAt,
    required this.sourceUrl,
    required this.verified,
  });

  final String id;
  final ListingType type;
  final String title;
  final String organization;
  final String description;
  final String eligibility;
  final String city;
  final String province;
  final String field;
  final String educationLevel;
  final DateTime lastDate;
  final DateTime postedAt;
  final String sourceUrl;
  final bool verified;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json['id'] as String,
    type: ListingType.fromKey(json['type'] as String? ?? ''),
    title: json['title'] as String,
    organization: json['organization'] as String? ?? '',
    description: json['description'] as String? ?? '',
    eligibility: json['eligibility'] as String? ?? '',
    city: json['city'] as String? ?? '',
    province: json['province'] as String? ?? '',
    field: json['field'] as String? ?? '',
    educationLevel: json['educationLevel'] as String? ?? '',
    lastDate: DateTime.parse(json['lastDate'] as String).toLocal(),
    postedAt: DateTime.parse(json['postedAt'] as String).toLocal(),
    sourceUrl: json['sourceUrl'] as String,
    verified: json['verified'] as bool? ?? false,
  );

  /// Whole calendar days from [now] until the deadline (negative if past).
  int daysLeft(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(lastDate.year, lastDate.month, lastDate.day);
    return due.difference(today).inDays;
  }

  bool isExpired(DateTime now) => daysLeft(now) < 0;
}

class Feed {
  const Feed({required this.updatedAt, required this.listings});

  final DateTime updatedAt;
  final List<Listing> listings;

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    listings: (json['listings'] as List)
        .map((e) => Listing.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
