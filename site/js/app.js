// Loads site/data/manifest.json, then each panel's JSON, and renders simple stat rows.
// Keep this small: layout and styling live in HTML/CSS.
async function load() {
  // Map init if map container exists
  if (document.getElementById('map')) {
    const map = L.map('map', {center: [45.42, -75.69], zoom: 5});
    // Add a tile layer: OSM (light) + optional dark toggle
    const toner = L.tileLayer('https://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png', {maxZoom: 19}).addTo(map);
    // Layer switcher
    const topo = L.tileLayer('http://localhost:8080/tiles/{z}/{x}/{y}.png', {maxZoom: 7, opacity: 0.6});
    const baseLayers = {
      'Stamen Toner': toner
    };
    const overlayLayers = {
      'Local Bathymetry': topo
    };
    L.control.layers(baseLayers, overlayLayers).addTo(map);
  }

  const status = document.getElementById("status");
  try {
    const manifest = await (await fetch("data/manifest.json")).json();
    status.textContent = "Updated " + new Date(manifest.generated).toLocaleString();
    for (const p of manifest.panels) {
      const el = document.querySelector(`#${p.id} .panel-body`);
      if (!el) continue;
      if (!p.ok) { el.innerHTML = `<p class="empty">Source unavailable: ${p.error}</p>`; continue; }
      const data = await (await fetch(`data/${p.id}.json`)).json();
      // TODO: render stations as .stat rows or an accessible <table>
      el.textContent = `${(data.stations || []).length} stations`;
    }
  } catch (e) {
    status.textContent = "No data yet. Run: python3 -m fetchers.run_all";
  }
}
load();
