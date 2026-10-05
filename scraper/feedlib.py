"""Validation and feed building for the verified jobs & scholarships board.

Only entries in data/curated.json (human-approved) are published. Scraped
items are written to pending.json for review and never reach users directly.
"""

from __future__ import annotations

import re
from datetime import date, datetime, time, timedelta, timezone

PKT = timezone(timedelta(hours=5))  # Pakistan Standard Time
TYPES = {"govt_job", "private_job", "scholarship", "internship"}
REQUIRED = ("id", "type", "title", "organization", "sourceUrl", "lastDate")

# Scam patterns: a listing containing any of these is rejected outright.
SCAM_PATTERNS = [
    r"easypaisa", r"jazz\s*cash", r"western\s*union", r"send\s+money",
    r"advance\s+fee", r"processing\s+fee", r"registration\s+fee\s+to\s+(?:be\s+)?(?:sent|paid)",
]
# Softer signal: government tests often charge a legitimate bank-challan fee.
FEE_WARNING = re.compile(r"\bfee\b", re.I)


def parse_deadline(value: str) -> datetime:
    """Accepts 'YYYY-MM-DD' (end of day, PKT) or a full ISO timestamp."""
    value = value.strip()
    if re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        d = date.fromisoformat(value)
        return datetime.combine(d, time(23, 59), tzinfo=PKT)
    dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
    return dt if dt.tzinfo else dt.replace(tzinfo=PKT)


def _norm(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", text.lower()).strip()


def validate(entry: dict) -> tuple[list[str], list[str]]:
    """Returns (errors, warnings). Any error means the entry is not published."""
    errors: list[str] = []
    warnings: list[str] = []
    for key in REQUIRED:
        if not str(entry.get(key, "")).strip():
            errors.append(f"missing {key}")
    if entry.get("type") not in TYPES:
        errors.append(f"invalid type {entry.get('type')!r}")
    url = str(entry.get("sourceUrl", ""))
    if url and not url.startswith("https://"):
        errors.append("sourceUrl must be https")
    if entry.get("lastDate"):
        try:
            parse_deadline(str(entry["lastDate"]))
        except ValueError:
            errors.append("lastDate is not a valid date")
    text = " ".join(
        str(entry.get(k, "")) for k in ("title", "description", "eligibility")
    )
    for pat in SCAM_PATTERNS:
        if re.search(pat, text, re.I):
            errors.append(f"scam pattern: {pat}")
    if not errors and FEE_WARNING.search(text):
        warnings.append("mentions a fee - confirm it is an official challan")
    return errors, warnings


def build_feed(curated: list[dict], now: datetime | None = None) -> tuple[dict, list[str]]:
    """Builds the feed dict the app downloads. Returns (feed, report lines)."""
    now = now or datetime.now(PKT)
    report: list[str] = []
    seen: set[tuple[str, str]] = set()
    listings: list[dict] = []

    for entry in curated:
        label = entry.get("id") or entry.get("title") or "?"
        errors, warnings = validate(entry)
        if errors:
            report.append(f"REJECT {label}: {'; '.join(errors)}")
            continue
        deadline = parse_deadline(str(entry["lastDate"]))
        if deadline.astimezone(PKT).date() < now.astimezone(PKT).date():
            report.append(f"EXPIRED {label}")
            continue
        key = (_norm(entry["title"]), _norm(entry["organization"]))
        if key in seen:
            report.append(f"DUPLICATE {label}")
            continue
        seen.add(key)
        for w in warnings:
            report.append(f"WARN {label}: {w}")
        listings.append(
            {
                "id": entry["id"],
                "type": entry["type"],
                "title": entry["title"].strip(),
                "organization": entry["organization"].strip(),
                "city": entry.get("city", ""),
                "province": entry.get("province", ""),
                "field": entry.get("field", ""),
                "educationLevel": entry.get("educationLevel", ""),
                "description": entry.get("description", ""),
                "eligibility": entry.get("eligibility", ""),
                "lastDate": deadline.isoformat(),
                "postedAt": entry.get("postedAt") or now.isoformat(),
                "sourceUrl": entry["sourceUrl"],
                "verified": True,  # curated entries are human-approved
            }
        )

    listings.sort(key=lambda l: l["lastDate"])
    feed = {"updatedAt": now.astimezone(timezone.utc).isoformat(), "listings": listings}
    return feed, report
