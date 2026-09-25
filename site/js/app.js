// Loads site/data/manifest.json, then each panel's JSON, and renders simple stat rows.
// Keep this small: layout and styling live in HTML/CSS.
async function load() {
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
