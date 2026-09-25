"""Run every enabled fetcher and write site/data/manifest.json listing what succeeded."""
import importlib
import json
from datetime import datetime, timezone

from .base import DATA, load_sources, write_panel

MODULES = {"chs_iwls": "chs_iwls", "meds_waves": "meds_waves", "cioos_pacific": "cioos_erddap",
           "cioos_atlantic": "cioos_erddap", "cioos_slgo": "cioos_erddap", "hakai": "cioos_erddap",
           "onc": "onc", "argo": "argo"}


def main():
    manifest = {"generated": datetime.now(timezone.utc).isoformat(), "panels": []}
    for src in load_sources():
        if not src.get("enabled") or src["id"] not in MODULES:
            continue
        try:
            mod = importlib.import_module(f"fetchers.{MODULES[src['id']]}")
            write_panel(src["id"], mod.fetch(src))
            manifest["panels"].append({"id": src["id"], "name": src["name"], "ok": True})
        except Exception as e:  # keep going so one broken source doesn't blank the dashboard
            manifest["panels"].append({"id": src["id"], "name": src["name"], "ok": False, "error": str(e)})
    DATA.mkdir(parents=True, exist_ok=True)
    (DATA / "manifest.json").write_text(json.dumps(manifest, indent=1))
    print(json.dumps(manifest, indent=1))


if __name__ == "__main__":
    main()
