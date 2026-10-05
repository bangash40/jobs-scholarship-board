from datetime import datetime

from feedlib import PKT, build_feed, parse_deadline, validate
from sources import guess_deadline, parse_cards, parse_links

NOW = datetime(2026, 10, 5, 12, 0, tzinfo=PKT)


def entry(**kw):
    base = {
        "id": "a",
        "type": "scholarship",
        "title": "HEC Need Based Scholarship",
        "organization": "HEC",
        "sourceUrl": "https://www.hec.gov.pk/x",
        "lastDate": "2026-10-20",
    }
    base.update(kw)
    return base


def test_date_only_means_end_of_day_pkt():
    assert parse_deadline("2026-10-20").isoformat() == "2026-10-20T23:59:00+05:00"


def test_valid_entry_is_published_and_marked_verified():
    feed, _ = build_feed([entry()], NOW)
    assert feed["listings"][0]["verified"] is True


def test_expired_entry_is_dropped_but_today_is_kept():
    feed, report = build_feed(
        [entry(id="old", lastDate="2026-10-04"), entry(id="today", title="B", lastDate="2026-10-05")],
        NOW,
    )
    assert [l["id"] for l in feed["listings"]] == ["today"]
    assert any(r.startswith("EXPIRED old") for r in report)


def test_non_https_and_missing_fields_are_rejected():
    assert validate(entry(sourceUrl="http://x.com"))[0]
    assert validate(entry(lastDate=""))[0]
    assert validate(entry(type="bogus"))[0]


def test_scam_wording_is_rejected_and_plain_fee_only_warns():
    errors, _ = validate(entry(description="Send fee via EasyPaisa to confirm"))
    assert errors
    errors, warnings = validate(entry(description="Fee Rs. 500 via bank challan"))
    assert not errors and warnings


def test_duplicates_are_removed():
    feed, report = build_feed([entry(id="a"), entry(id="b")], NOW)
    assert len(feed["listings"]) == 1
    assert any(r.startswith("DUPLICATE") for r in report)


def test_parse_links_filters_menu_items_and_resolves_urls():
    html = """<a href="/home">Home</a>
    <a href="/s/1">Need Based Scholarship Programme 2026</a>
    <a href="/s/1">Need Based Scholarship Programme 2026</a>
    <a href="http://insecure.com/x">Another Scholarship Programme here</a>"""
    src = {"id": "t", "name": "T", "type": "scholarship", "url": "https://t.gov.pk/list", "include": "scholar"}
    found = parse_links(src, html)
    assert [c["sourceUrl"] for c in found] == ["https://t.gov.pk/s/1"]
    assert found[0]["lastDate"] == ""


def test_parse_links_href_pattern_catches_short_link_text():
    html = "<marquee>Advertisement No. <a href='Adds/Advt No-10 2026.pdf'>10/2026</a></marquee><a href='/x.pdf'>Some other long document name</a>"
    src = {"id": "p", "name": "P", "type": "govt_job", "url": "https://p.gov.pk/Jobs.aspx", "hrefPattern": "Adds/"}
    found = parse_links(src, html)
    assert len(found) == 1
    assert found[0]["title"].startswith("Advertisement No. 10/2026")
    assert found[0]["sourceUrl"] == "https://p.gov.pk/Adds/Advt%20No-10%202026.pdf"


def test_parse_cards_reads_title_and_link():
    html = "<ul><li class='c'><div class='d'>HEC Need Based</div><a href='/p.aspx'>go</a></li><li class='c'><div class='d'>No link</div></li></ul>"
    src = {"id": "h", "name": "H", "type": "scholarship", "url": "https://h.gov.pk/list", "item": "li.c", "title": ".d"}
    found = parse_cards(src, html)
    assert [(c["title"], c["sourceUrl"]) for c in found] == [("HEC Need Based", "https://h.gov.pk/p.aspx")]


def test_guess_deadline_reads_date_near_phrase():
    assert guess_deadline("Apply now. Last date: 15-Nov-2026") == "15-Nov-2026"
    assert guess_deadline("no dates here") is None
