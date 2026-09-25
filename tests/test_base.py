from fetchers.base import load_sources


def test_sources_have_ids_and_urls():
    for s in load_sources():
        assert s["id"] and s["base_url"].startswith("https://")
