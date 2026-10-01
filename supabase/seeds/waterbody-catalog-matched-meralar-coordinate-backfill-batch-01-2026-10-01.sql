-- Backfill missing Olta Atlası mera coordinates from exact normalized water-body catalog matches.
-- This batch only copies general waterbody coordinates when the normalized name and province match.
-- It does not add fishing-access points or infer coordinates from settlements.
-- 18 fishing_area records were updated in the live database on 2026-10-01.
BEGIN;
WITH fa AS (
  SELECT f.id, f.name, f.province_name, internal.water_name_key(f.name) AS name_key
  FROM public.fishing_areas f
  WHERE f.latitude IS NULL OR f.longitude IS NULL
),
wb AS (
  SELECT
    w.id,
    p.name AS province_name,
    w.latitude,
    w.longitude,
    w.coordinate_confidence_grade,
    w.source_reference,
    internal.water_name_key(substring(w.name FROM position('-' IN w.name) + 1)) AS key1,
    internal.water_name_key(
      substring(
        substring(w.name FROM position('-' IN w.name) + 1)
        FROM position(' ' IN substring(w.name FROM position('-' IN w.name) + 1)) + 1
      )
    ) AS key2
  FROM public.water_bodies w
  JOIN public.provinces p ON p.id = w.province_id
  WHERE w.latitude IS NOT NULL
    AND w.longitude IS NOT NULL
    AND w.verification_status = 'verified'
    AND w.coordinate_confidence_grade IN ('A', 'B', 'C')
),
ranked_matches AS (
  SELECT
    fa.id AS fishing_area_id,
    wb.latitude,
    wb.longitude,
    wb.coordinate_confidence_grade,
    wb.source_reference,
    row_number() OVER (
      PARTITION BY fa.id
      ORDER BY CASE wb.coordinate_confidence_grade WHEN 'A' THEN 0 WHEN 'B' THEN 1 ELSE 2 END, wb.id
    ) AS rn
  FROM fa
  JOIN wb ON wb.key1 = fa.name_key OR wb.key2 = fa.name_key
  WHERE lower(extensions.unaccent(fa.province_name)) = lower(extensions.unaccent(wb.province_name))
),
chosen AS (
  SELECT * FROM ranked_matches WHERE rn = 1
)
UPDATE public.fishing_areas AS f
SET latitude = c.latitude,
    longitude = c.longitude,
    coordinates_imported = true,
    location_confidence_grade = c.coordinate_confidence_grade,
    coordinate_status = 'province_checked_source_candidate',
    coordinate_note = 'General waterbody coordinate matched by normalized name and province against Balık Rehberi water_bodies catalog. Source reference: ' || coalesce(c.source_reference, 'not recorded') || '. Not a fishing-access point.',
    source_checked_at = now(),
    updated_at = now()
FROM chosen c
WHERE f.id = c.fishing_area_id
  AND (f.latitude IS NULL OR f.longitude IS NULL);
COMMIT;
