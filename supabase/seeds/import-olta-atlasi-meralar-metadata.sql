-- Rebuildable metadata-only import from Olta Atlası's public mera archive.
-- Coordinates and source-written descriptions are intentionally not copied.
-- Requires the existing extensions.http_get helper in the Supabase project.
WITH response AS (
  SELECT (extensions.http_get('https://oltaatlasi.com/meralar/')).content AS html
), cards AS (
  SELECT regexp_split_to_table(html, '</article>') AS card FROM response
), parsed AS (
  SELECT
    (regexp_match(card, 'data-slug="([^"]+)"'))[1] AS source_slug,
    (regexp_match(card, '<h3><a href="/meralar/[^\"]+"[^>]*>([^<]+)</a></h3>'))[1] AS name,
    nullif((regexp_match(card, 'data-province="([^"]*)"' ))[1], '') AS province_name,
    nullif((regexp_match(card, 'data-district="([^"]*)"' ))[1], '') AS district_name,
    nullif((regexp_match(card, 'data-zone="([^"]*)"' ))[1], '') AS zone_name,
    nullif((regexp_match(card, 'data-water="([^"]*)"' ))[1], '') AS water_type,
    (regexp_match(card, 'data-confidence="([A-D])"'))[1] AS source_grade,
    (regexp_match(card, '<h3><a href="(/meralar/[^\"]+)"'))[1] AS route_path
  FROM cards
  WHERE card LIKE '%class="mera-card"%'
)
INSERT INTO public.fishing_areas (
  source_slug, name, province_name, district_name, zone_name, water_type,
  source_grade, location_confidence_grade, source_url, source_name,
  general_note, coordinates_imported, source_checked_at, updated_at
)
SELECT source_slug, name, province_name, district_name, zone_name, water_type,
  source_grade, source_grade, 'https://oltaatlasi.com' || route_path, 'Olta Atlası',
  'Kaynak güven seviyesi ' || source_grade || '. Bu kayıt genel mera rehberidir; kıyı erişimi ve güncel av uygunluğu ayrıca kontrol edilmelidir.',
  false, now(), now()
FROM parsed
WHERE source_slug IS NOT NULL AND name IS NOT NULL AND source_grade IS NOT NULL AND route_path IS NOT NULL
ON CONFLICT (source_slug) DO UPDATE SET
  name=excluded.name, province_name=excluded.province_name, district_name=excluded.district_name,
  zone_name=excluded.zone_name, water_type=excluded.water_type, source_grade=excluded.source_grade,
  location_confidence_grade=excluded.location_confidence_grade, source_url=excluded.source_url,
  source_checked_at=now(), updated_at=now();
