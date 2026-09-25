"""Fetcher: cioos_erddap. TODO: implement fetch() and return the panel payload (see base.write_panel)."""
from .base import get_json, write_panel


def fetch(source):
    # TODO: call the API at source["base_url"], normalise units and timestamps (UTC ISO 8601),
    # and return {"source": source["name"], "updated": ..., "units": {...}, "stations": [...]}.
    raise NotImplementedError
