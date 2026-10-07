# Canada Ocean Dashboard

A local dashboard that pulls live and recent oceanographic data from public sources and shows it in a hand-built HTML/CSS interface at `http://localhost:8000`.

The point of the project is the front end: semantic HTML, a CSS design system (custom properties, grid and flexbox layout, responsive breakpoints, dark mode), and accessible data display. The Python side only fetches and normalises data into JSON files that the page reads. No frameworks.

## What it shows (planned)

| Panel | Data | Source |
|---|---|---|
| Tides and water levels | Observed and predicted water level at CHS tide stations | DFO Canadian Hydrographic Service, IWLS API |
| Wave buoys | Significant wave height, period, sea temperature | DFO Marine Environmental Data Section (MEDS) and ECCC MSC Datamart marine obs |
| Sea surface temperature | BC lightstation SST and salinity series | DFO BC Lightstations, via CIOOS Pacific ERDDAP|
| Coastal observatories | Cabled observatory sensor readings | Ocean Networks Canada Oceans 3.0 API (free token) |
| Regional ocean data | Selected CIOOS datasets per region | CIOOS Pacific, Atlantic and St. Lawrence ERDDAP servers |
| Research stations | Hakai Institute sensor network | Hakai ERDDAP |
| Profiling floats | Argo profiles in Canadian waters | Argo Canada / MEDS |

Each source has its own fetcher in `fetchers/`. Endpoints are listed in `fetchers/sources.json` and marked `verified: false` until you've confirmed them. Check each API's terms of use before building on it.

## How it runs

```
python3 -m fetchers.run_all     # fetch every enabled source into site/data/*.json
python3 serve.py                # serve site/ at http://localhost:8000
```

Python 3.11+, standard library only for now (urllib, json, csv). Add `requests` later if you want.

## Layout

```
fetchers/
  sources.json      # every source, its endpoint, refresh interval, enabled flag
  base.py           # shared helpers: HTTP get with timeout and cache, JSON writer, unit normalisation
  chs_iwls.py       # tides and water levels
  meds_waves.py     # wave buoys
  cioos_erddap.py   # generic ERDDAP tabledap fetcher (CIOOS regions, Hakai, lightstations)
  onc.py            # Ocean Networks Canada (needs ONC_TOKEN env var)
  argo.py           # Argo floats
  run_all.py        # runs every enabled fetcher, writes site/data/manifest.json
site/
  index.html        # the dashboard
  css/tokens.css    # colours, type scale, spacing as custom properties, light and dark
  css/layout.css    # page grid, panels, responsive breakpoints
  css/components.css# cards, stat tiles, tables, sparklines, status badges
  js/app.js         # loads site/data/*.json and renders panels (kept small; HTML/CSS does the work)
  data/             # generated JSON, gitignored
serve.py            # tiny localhost server
tests/              # fetcher tests against saved sample responses
```

## Build plan

1. **Week 1: front end first, with mock data.** Build `index.html` and the three CSS files against `site/data/sample_*.json`. Get the layout, dark mode and mobile width right before touching live data.
2. **Week 1–2: live fetchers.** CHS IWLS first (simplest JSON API), then one ERDDAP source, then the rest.
3. **Week 2: polish.** Accessible tables for every chart, `prefers-reduced-motion`, keyboard focus styles, a print stylesheet, Lighthouse score over 90.
4. **Stretch:** a station map in pure SVG, a "compare two stations" view, scheduled refresh with cron.

## What this shows employers

- HTML/CSS: semantic structure, a token-based design system, responsive grid layouts, dark mode, accessibility.
- Data work: pulling from several real government and research APIs, cleaning and normalising units and timestamps.
- Domain: Earth and ocean science, which matches the B.Sc.
