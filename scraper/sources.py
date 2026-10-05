"""Fetches candidate listings from configured official sources.

Candidates are leads for a human to verify, not publishable listings.
"""

from __future__ import annotations

import hashlib
import re
import time
from urllib.parse import urljoin

import feedparser
import requests
from bs4 import BeautifulSoup
from requests.utils import requote_uri

USER_AGENT = "JobsScholarshipBoardBot/0.1 (+https://github.com/bangash40/jobs-scholarship-board)"
TIMEOUT = 20
DELAY_SECONDS = 2  # be polite between requests

DATE_HINT = re.compile(
    r"(?:last\s*date|deadline|closing)[^0-9]{0,20}"
    r"(\d{1,2}[-/. ]\w{3,9}[-/. ]\d{2,4}|\d{1,2}[-/.]\d{1,2}[-/.]\d{2,4})",
    re.I,
)


def candidate_id(source_id: str, url: str) -> str:
    return f"{source_id}-{hashlib.sha1(url.encode()).hexdigest()[:8]}"


def guess_deadline(text: str) -> str | None:
    """Returns the raw date text near a 'last date' phrase, if any. Unparsed on purpose."""
    m = DATE_HINT.search(text)
    return m.group(1) if m else None


def _candidate(source: dict, title: str, url: str, context: str = "") -> dict:
    return {
        "id": candidate_id(source["id"], url),
        "type": source["type"],
        "title": " ".join(title.split()),
        "organization": source["name"],
        "sourceUrl": url,
        "lastDate": "",  # reviewer must fill this in from the official page
        "guessedDeadline": guess_deadline(f"{title} {context}"),
        "foundOn": source["url"],
    }


def _abs_url(base: str, href: str) -> str:
    return requote_uri(urljoin(base, href.strip()))


def parse_links(source: dict, html: str) -> list[dict]:
    """Anchors on a page. `include` filters by title/href text; `hrefPattern`
    additionally accepts links with short text (e.g. '10/2026'), using the
    surrounding text as the title."""
    soup = BeautifulSoup(html, "html.parser")
    include = re.compile(source["include"], re.I) if source.get("include") else None
    href_pat = re.compile(source["hrefPattern"], re.I) if source.get("hrefPattern") else None
    seen: set[str] = set()
    out: list[dict] = []
    for a in soup.find_all("a", href=True):
        title = " ".join(a.get_text().split())
        context = " ".join(a.parent.get_text().split()) if a.parent else ""
        by_href = bool(href_pat and href_pat.search(a["href"]))
        if by_href:
            title = context or title
        elif len(title) < 15:  # skip menu items like "Home", "Contact"
            continue
        elif include and not include.search(title + " " + a["href"]):
            continue
        elif href_pat and not include:
            continue
        url = _abs_url(source["url"], a["href"])
        if not url.startswith("https://") or url in seen:
            continue
        seen.add(url)
        out.append(_candidate(source, title, url, context))
    return out


def parse_cards(source: dict, html: str) -> list[dict]:
    """Repeated blocks: `item` selects each card, `title` the title inside it.
    The card's first link becomes the source URL."""
    soup = BeautifulSoup(html, "html.parser")
    seen: set[str] = set()
    out: list[dict] = []
    for card in soup.select(source["item"]):
        title_el = card.select_one(source["title"])
        link = card.find("a", href=True)
        if not title_el or not link:
            continue
        url = _abs_url(source["url"], link["href"])
        if not url.startswith("https://") or url in seen:
            continue
        seen.add(url)
        out.append(_candidate(source, title_el.get_text(), url, card.get_text(" ")))
    return out


def parse_rss(source: dict, body: bytes) -> list[dict]:
    feed = feedparser.parse(body)
    out = []
    for e in feed.entries:
        url = e.get("link", "")
        if url.startswith("https://"):
            out.append(_candidate(source, e.get("title", ""), url, e.get("summary", "")))
    return out


def fetch_source(source: dict) -> list[dict]:
    res = requests.get(source["url"], headers={"User-Agent": USER_AGENT}, timeout=TIMEOUT)
    res.raise_for_status()
    if source["kind"] == "rss":
        return parse_rss(source, res.content)
    if source["kind"] == "cards":
        return parse_cards(source, res.text)
    return parse_links(source, res.text)


def fetch_all(sources: list[dict]) -> tuple[list[dict], list[str]]:
    """Fetches every enabled source. One failing source never stops the others."""
    candidates: list[dict] = []
    errors: list[str] = []
    for source in sources:
        if not source.get("enabled", True):
            continue
        try:
            found = fetch_source(source)
            candidates.extend(found)
        except Exception as exc:  # report and continue
            errors.append(f"{source['id']}: {exc}")
        time.sleep(DELAY_SECONDS)
    return candidates, errors
