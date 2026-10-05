import '../models/listing.dart';

/// Where reports of suspicious listings are sent. If empty, the report opens a
/// pre-filled GitHub issue instead (reporter needs a GitHub account).
const String kReportEmail = '';

const String _issuesUrl =
    'https://github.com/bangash40/jobs-scholarship-board/issues/new';

enum ReportReason {
  fee('Asks for a fee or payment'),
  fake('Looks fake or a scam'),
  expired('Deadline is wrong or expired'),
  link('Link is broken or wrong'),
  other('Something else');

  const ReportReason(this.description);

  /// Always English, so the reviewer can read it whatever language the app is in.
  final String description;
}

/// Builds the link that opens the user's email app (or GitHub) with the report
/// filled in. Contains only the listing's public details, nothing about the user.
Uri reportUri(Listing listing, ReportReason reason, {String email = kReportEmail}) {
  final subject = 'Report: ${listing.title}';
  final body =
      'Listing ID: ${listing.id}\n'
      'Title: ${listing.title}\n'
      'Organization: ${listing.organization}\n'
      'Link: ${listing.sourceUrl}\n'
      'Reason: ${reason.description}\n\n'
      'Details (optional):\n';

  if (email.isNotEmpty) {
    // Uri(queryParameters) encodes spaces as '+', which mail apps show literally.
    final query = [
      'subject=${Uri.encodeComponent(subject)}',
      'body=${Uri.encodeComponent(body)}',
    ].join('&');
    return Uri.parse('mailto:$email?$query');
  }
  return Uri.parse(_issuesUrl).replace(
    queryParameters: {
      'title': subject,
      'body': body,
      'labels': 'report',
    },
  );
}
