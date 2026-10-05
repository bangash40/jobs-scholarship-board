# Feed scraper

Builds the `feed.json` the Flutter app downloads.

**Nothing scraped goes live automatically.** Scraped items are *leads*
(`public/pending.json`). Only entries you add to `data/curated.json` are
published, after you confirm the deadline on the official page.

## Daily workflow

1. Run the scraper (or download the `pending-review` artifact from the latest
   GitHub Actions run) and list the leads: `python curate.py --list`.
2. For a lead worth publishing, open its official page and confirm the deadline
   and eligibility yourself.
3. Add it, with the deadline you confirmed:

   ```
   python curate.py hec-scholarships-5acc5832 --last-date 2026-11-30 --city Islamabad --province Federal --education master
   ```

   The entry is validated with the same rules as the build and refused if it
   fails. Extra flags: `--title --field --description --eligibility`. You can
   also edit `data/curated.json` by hand using the format below.
4. Commit `data/curated.json`. The workflow rebuilds and republishes `feed.json`.

Entry format:

```json
{
  "id": "hec-need-based-2026",
  "type": "scholarship",
  "title": "HEC Need Based Scholarship",
  "organization": "Higher Education Commission",
  "city": "Islamabad",
  "province": "Federal",
  "field": "All disciplines",
  "educationLevel": "bachelor",
  "description": "Short summary.",
  "eligibility": "Who can apply.",
  "lastDate": "2026-11-30",
  "sourceUrl": "https://www.hec.gov.pk/..."
}
```

`type` is one of `govt_job`, `private_job`, `scholarship`, `internship`.
`lastDate` is `YYYY-MM-DD` (end of day, Pakistan time).

## Automatic checks when building

- Required fields present, `sourceUrl` is `https://`, valid type and date.
- Rejected if the text matches scam patterns ("send money", "advance fee",
  "processing fee", Western Union, ...). Mobile-wallet names (EasyPaisa,
  JazzCash) are rejected too, except on `.gov.pk` sources where they only warn,
  because official adverts such as PPSC's list them as fee channels. A plain
  mention of "fee" only warns, since official tests can charge a bank-challan fee.
- Expired listings are dropped (the day after the last date).
- Duplicates (same title + organization) are dropped.

## Run locally

```
pip install -r requirements.txt
python -m pytest -q
python run.py             # scrape + build
python run.py --no-scrape # rebuild from curated.json only
```

## Adding a source

Edit `sources.json`. Kinds:

- `cards`: repeated blocks. Needs `item` (CSS selector per card) and `title`.
- `links`: anchors on a page. Optional `include` (regex on text/href) and
  `hrefPattern` (accept links like `Adds/...pdf` even with short text).
- `rss`: any RSS/Atom feed.

Only add official sources, and respect each site's terms and `robots.txt`.
Do not scrape Facebook/WhatsApp groups or LinkedIn/Indeed/Rozee.

## Publishing

Enable GitHub Pages with source **GitHub Actions** (repo Settings > Pages).
The feed is then served at `https://<user>.github.io/<repo>/feed.json`; set that
as `kFeedUrl` in `lib/services/feed_repository.dart`.
