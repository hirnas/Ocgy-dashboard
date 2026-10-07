#!/usr/bin/env bash
# gebco_prepare.sh – full conversion + Canadian crop + optional margin
#
# Usage:
#   bash scripts/gebco_prepare.sh          # default 5° margin
#   MARGIN=2 bash scripts/gebco_prepare.sh # 2° margin
#
# Output: site/data/GEBCO_2026_canada_ext.tif
# Afterward:
#   ./scripts/generate_tiles.sh site/data/GEBCO_2026_canada_ext.tif

set -euo pipefail

# ---------- Configurable paths ----------
NC_SRC="site/data/GEBCO_2026/GEBCO_2026.nc"
BASE_TIF="site/data/GEBCO_2026_canada.tif"
EXT_TIF="site/data/GEBCO_2026_canada_ext.tif"

# ---------- Canadian bounds (WGS84) ----------
BASE_ULON=-141.0
BASE_ULAT=83.0
BASE_LRON=-52.0
BASE_LRLAT=41.5

# ---------- Optional margin in degrees (default 5°) ----------
MARG=${MARGIN:-5.0}

# Compute extended bounds
EXT_ULON=$(echo "$BASE_ULON - $MARG" | bc -l)
EXT_ULAT=$(echo "$BASE_ULAT + $MARG" | bc -l)
EXT_LRON=$(echo "$BASE_LRON + $MARG" | bc -l)
EXT_LRLAT=$(echo "$BASE_LRLAT - $MARG" | bc -l)
# -------------------------------------

# 1. Convert NetCDF to GeoTIFF (using band 1, depth)
if [ ! -f "$NC_SRC" ]; then
  echo "Error: $NC_SRC not found."
  exit 1
fi

echo "Converting NetCDF to GeoTIFF…"

gdal_translate -b 1 -scale -32768 32767 -8000 0 255 -ot Int16 -of GTiff "$NC_SRC" "$BASE_TIF"

# 2. Crop to Canada (±margin) and rescale
if [ ! -f "$BASE_TIF" ]; then
  echo "Error: $BASE_TIF was not created."
  exit 1
fi

echo "Cropping to Canada ±$MARG° …"

gdal_translate \
  -projwin "$EXT_ULON" "$EXT_ULAT" "$EXT_LRON" "$EXT_LRLAT" \
  -scale -9999 0 -8000 0 255 \
  -ot Int16 -of GTiff "$BASE_TIF" "$EXT_TIF"

# 3. Summary

echo "Resulting file: $EXT_TIF"

gdalinfo "$EXT_TIF" | grep -E 'Size is|Upper left|Lower right|Pixel Size'

# 4. Reminder

echo "You can tile it now with:" 

echo "  ./scripts/generate_tiles.sh \"$EXT_TIF\""

