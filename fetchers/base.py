"""Shared helpers for every fetcher: HTTP GET with timeout, a small on-disk cache, and a JSON writer."""
import json
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "site" / "data"
CACHE = ROOT / ".cache"
UA = "canada-ocean-dashboard/0.1 (personal project)"


def load_sources():
    return json.loads((Path(__file__).parent / "sources.json").read_text())["sources"]


def get_json(url, max_age_s=900, timeout=20):
    """GET a URL and parse JSON, reusing a cached copy younger than max_age_s."""
    CACHE.mkdir(exist_ok=True)
    key = CACHE / (str(abs(hash(url))) + ".json")
    if key.exists() and time.time() - key.stat().st_mtime < max_age_s:
        return json.loads(key.read_text())
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        body = r.read().decode("utf-8")
    key.write_text(body)
    return json.loads(body)


def write_panel(name, payload):
    """Write one panel's data to site/data/<name>.json in the shape the front end expects:
    {"source": str, "updated": iso8601, "units": {...}, "stations": [...]}"""
    DATA.mkdir(parents=True, exist_ok=True)
    (DATA / f"{name}.json").write_text(json.dumps(payload, indent=1))
