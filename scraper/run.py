"""Entry point: builds public/feed.json (published) and public/pending.json (review).

Usage:  python run.py            # scrape + build
        python run.py --no-scrape  # rebuild feed from curated.json only
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from feedlib import build_feed
from sources import fetch_all

ROOT = Path(__file__).parent
OUT = ROOT / "public"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-scrape", action="store_true")
    args = parser.parse_args()

    curated = json.loads((ROOT / "data" / "curated.json").read_text(encoding="utf-8"))
    feed, report = build_feed(curated)

    OUT.mkdir(exist_ok=True)
    write_json(OUT / "feed.json", feed)
    print(f"feed.json: {len(feed['listings'])} verified listings")
    for line in report:
        print(" ", line)

    failed = False
    if not args.no_scrape:
        sources = json.loads((ROOT / "sources.json").read_text(encoding="utf-8"))
        candidates, errors = fetch_all(sources)
        known = {c["sourceUrl"] for c in curated}
        pending = [c for c in candidates if c["sourceUrl"] not in known]
        write_json(OUT / "pending.json", pending)
        print(f"pending.json: {len(pending)} candidates awaiting review")
        for err in errors:
            print("  SOURCE FAILED", err)
        # Fail loudly only if every source failed, so an outage is noticed.
        failed = bool(errors) and not candidates

    return 1 if failed else 0


def write_json(path: Path, data) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    sys.exit(main())
