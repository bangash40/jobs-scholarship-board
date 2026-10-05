# Jobs & Scholarships Board

A mobile app (Flutter, Android first) that gives Pakistani students and job-seekers
one trustworthy feed of government jobs, private jobs, scholarships and
internships, with deadline reminders. Every listing links to an official source
and is checked by a person before it appears.

Runs entirely on free tiers: the app reads a static `feed.json` hosted on GitHub
Pages, and a GitHub Actions job rebuilds that file.

## Features

- Feed sorted by nearest deadline, with colour-coded urgency and a verified badge
- Search, type chips, "Closing soon", and city / education / field filters
- Optional interests setup and a **For you** view
- Save listings and get deadline reminders (7, 2 and 1 days before, selectable),
  scheduled on the device with no server
- Share a listing on WhatsApp, and report a suspicious one
- Urdu and English with right-to-left layout; light and dark themes
- Works offline from the last synced feed

## How the data flows

```
sources (HEC, PPSC, ...) --scrape--> scraper/public/pending.json   (private review queue)
                                          | you confirm deadline + link
                                          v
                              scraper/data/curated.json           (human-approved)
                                          | build + validate
                                          v
                              feed.json on GitHub Pages  --->  app (cached with Hive)
```

Nothing scraped is published automatically. See [scraper/README.md](scraper/README.md)
for the review workflow, validation rules and how to add sources.

## Project layout

| Path | What it is |
| --- | --- |
| `lib/screens`, `lib/widgets` | UI |
| `lib/services` | feed loading and cache, saved items, reminders, language, preferences, reports |
| `lib/l10n` | English and Urdu strings (ARB) and generated code |
| `lib/theme` | colour palette and light/dark themes |
| `scraper/` | Python pipeline that builds `feed.json` |
| `.github/workflows/feed.yml` | scheduled build and publish |

## Run the app

```
flutter pub get
flutter run
```

Run the tests with `flutter test` (app) and `python -m pytest -q` inside `scraper/`.

After editing `lib/l10n/*.arb`, run `flutter gen-l10n`.

## Configuration

- **Feed URL**: `kFeedUrl` in `lib/services/feed_repository.dart`. Empty means the
  bundled sample feed (`assets/feed.json`) is used.
- **Report address**: `kReportEmail` in `lib/services/report_service.dart`. Empty
  opens a pre-filled GitHub issue instead.

## Before a Play Store release

- Replace the placeholder application id `com.example.jobs_scholarship_board`.
- Create a release signing key; release builds currently use the debug key.
- Set `kFeedUrl` and curate real listings, then remove the sample feed.
