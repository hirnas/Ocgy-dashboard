"""Serve site/ at http://localhost:8000 (localhost only)."""
import functools
import http.server
from pathlib import Path

SITE = Path(__file__).resolve().parent / "site"
handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(SITE))
print("Serving http://localhost:8000  (Ctrl+C to stop)")
http.server.ThreadingHTTPServer(("127.0.0.1", 8000), handler).serve_forever()
