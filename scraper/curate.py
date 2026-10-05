"""Turn a reviewed lead from pending.json into a published entry in curated.json.

    python curate.py --list
    python curate.py hec-scholarships-1a2b3c4d --last-date 2026-11-30 \
        --city Islamabad --province Federal --education master

Only run this after opening the lead's official page and confirming the
deadline yourself. The entry is validated with the same rules as the build.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from feedlib import validate

ROOT = Path(__file__).parent
PENDING = ROOT / "public" / "pending.json"
CURATED = ROOT / "data" / "curated.json"

# CLI flag -> entry field
FIELDS = {
    "title": "title",
    "city": "city",
    "province": "province",
    "field": "field",
    "education": "educationLevel",
    "description": "description",
    "eligibility": "eligibility",
}


def make_entry(lead: dict, last_date: str, **overrides: str | None) -> dict:
    """Builds a curated entry from a scraped lead plus what the reviewer confirmed."""
    entry = {
        "id": lead["id"],
        "type": lead["type"],
        "title": lead["title"],
        "organization": lead["organization"],
        "sourceUrl": lead["sourceUrl"],
        "lastDate": last_date,
    }
    for key, value in overrides.items():
        if value:
            entry[FIELDS.get(key, key)] = value
    return entry


def add_entry(entry: dict, curated: list[dict]) -> list[str]:
    """Appends [entry] to [curated]. Returns error messages; nothing is added on error."""
    errors, _ = validate(entry)
    if any(c["id"] == entry["id"] or c["sourceUrl"] == entry["sourceUrl"] for c in curated):
        errors.append("already in curated.json")
    if not errors:
        curated.append(entry)
    return errors


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    ap.add_argument("lead_id", nargs="?", help="id of a lead in public/pending.json")
    ap.add_argument("--list", action="store_true", help="show pending leads")
    ap.add_argument("--last-date", help="confirmed deadline, YYYY-MM-DD")
    for flag in FIELDS:
        ap.add_argument(f"--{flag}")
    args = ap.parse_args()

    if not PENDING.exists():
        print("No public/pending.json yet. Run: python run.py")
        return 1
    pending = json.loads(PENDING.read_text(encoding="utf-8"))

    if args.list or not args.lead_id:
        for lead in pending:
            print(f"{lead['id']}  [{lead['type']}]  {lead['title'][:70]}")
        return 0

    lead = next((l for l in pending if l["id"] == args.lead_id), None)
    if lead is None:
        print(f"No lead with id {args.lead_id!r}. Use --list.")
        return 1
    if not args.last_date:
        print("--last-date is required: confirm it on the official page first.")
        return 1

    overrides = {k: getattr(args, k) for k in FIELDS}
    entry = make_entry(lead, args.last_date, **overrides)
    curated = json.loads(CURATED.read_text(encoding="utf-8"))
    errors = add_entry(entry, curated)
    if errors:
        print("Not added:", "; ".join(errors))
        return 1
    CURATED.write_text(json.dumps(curated, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Added {entry['id']} ({entry['lastDate']}). Commit curated.json to publish.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
