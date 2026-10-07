#!/usr/bin/env bash
# generate_tiles.sh – generate an online‑ready raster tile set from a GEBCO GeoTIFF
# Usage:  ./generate_tiles.sh /path/to/gebco-geographic-2020.tif
# The script creates site/data/tiles/ with z=5‑7 tiles.

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 /path/to/gebco-geographic-2020.tif"
  exit 1
fi

TIF=$1
TILEDIR="../data/tiles"

# Create output directory
mkdir -p "$TILEDIR"

# 1. Convert to 8‑bit PNG (alpha for land) – keep transparency
#    We map [0, 8000] m to 0–255 ; anything above 8000 is set to max 255.
#    Note: GEBCO uses negative depths, so -8000 to 0 maps to 0–255.

# Ensure GDAL is available
if ! command -v gdal_translate &>/dev/null; then
  echo "gdal_translate not found – install GDAL"
  exit 1
fi

# Step 1: scale raster to 0-255 for PNG, clip at ±8000
# Use -scale -9999 0 8000 0 255 to map depths to 0-255, keep nodata for land
# Output format GTiff for intermediate step
TEMP_TIF="temp_gebco_scaled.tif"

gdal_translate -scale -9999 0 -8000 0 255 -of GTiff "$TIF" "$TEMP_TIF"

# Step 2: Build tile pyramid
# Ensure gdal2tiles is available
if ! command -v gdal2tiles.py &>/dev/null; then
  echo "gdal2tiles.py not found – install gdal tools"
  exit 1
fi

# Build tiles for z=5-7
# The tiles will be written relative to TILEDIR
# Use -w none to avoid a web page output
# Use --processes to use all CPUs if available

gdal2tiles.py -p raster -z 5-7 -w none -o "$TILEDIR" "$TEMP_TIF"

# Clean up intermediate file
rm "$TEMP_TIF"

echo "Tiles generated in $TILEDIR"
