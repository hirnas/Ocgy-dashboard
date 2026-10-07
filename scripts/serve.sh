#!/usr/bin/env bash
# serve.sh - launch the dashboard site on http://localhost:8000
# and the optional local tile server on http://localhost:8080

set -euo pipefail

# change to project root
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
ROOT_DIR=$(realpath "$SCRIPT_DIR/../")
cd "$ROOT_DIR"

# Serve the site (port 8000)
python -m http.server 8000 --directory site &

# If a tiles directory exists under site/data, serve it on port 8080
if [ -d "site/data/tiles" ]; then
  echo "Serving local tiles at http://localhost:8080" &
  python -m http.server 8080 --directory site/data/tiles &
fi

# Keep script alive until user interrupts
wait
