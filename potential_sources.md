# Potential Ocean Data Sources That Require a Key or Registration

## Sources Requiring a Key / Registration

| Service | Data Provided | Endpoint | Key / Registration Requirement | Notes (Canada Coverage)
|---------|---------------|----------|------------------------------|------------------------
| Copernicus Marine Service (CERS) – Marine‑Observation‑API | Sea‑surface temperature, salinity, chlorophyll‑a, currents | `https://marine.copernicus.eu/portal/home` (REST‑JSON) | Free token via Copernicus registration | Global grid & station data include Canadian regions.
| Copernicus Marine Environment Monitoring Service (CMEMS) | Gridded datasets (OSCAR, CMEMS, ...) | `https://marine.copernicus.eu/map-services` | Free token after registration | Global coverage; Canadian grids present.
| NOAA Tides & Currents (NOAA API) | Tide predictions, wave height, wind, sea‑level rise | `https://tidesandcurrents.noaa.gov/api` | Free NASA NOAA key (obtain via NOAA site) | Global, includes Canadian stations.
| PICES (Pacific Marine Environmental Information System) | Sea temperature, salinity, currents (S‑Band) | `https://pices.org/api/` | Free token after registration | Focus on North‑Pacific, many stations off Canadian coast.
| ESA Sentinel‑3 SLSTR | Sea‑surface temperature, chlorophyll, ocean colour | `https://scihub.copernicus.eu/` | Free after registration | Satellite coverage includes Canadian coastal waters.

## Sources that Provide Data without a Key

| Service | Data Provided | Endpoint | Notes (Canada Coverage)
|---------|---------------|----------|------------------------
| NOAA USGS OGER – OGDS | Surface temperature, salinity, currents | `https://www.ngdc.noaa.gov/marine/ogdas` | No key | Global data includes Canadian coastal regions.
| Oceanography Global Float Data (Argo Global) | Temperature, salinity, depth profiles | `https://www.argo.ucsd.edu/` | No key | Argo float coverage extends into Canadian waters.

---

Feel free to add the key‑required services to `fetchers/sources.json` after testing and setting "verified": true. The non‑key services can be added directly; no authentication is required.
