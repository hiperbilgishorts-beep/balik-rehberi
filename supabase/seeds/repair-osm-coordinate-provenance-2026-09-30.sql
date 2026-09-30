-- Repair source_id for coordinate records whose provenance was already recorded.
-- This changes no coordinates; it attaches the existing OpenStreetMap source row.
-- Idempotent and intentionally limited to records with Photon/OSM provenance.
UPDATE public.water_bodies AS w
SET source_id = (
  SELECT s.id
  FROM public.sources AS s
  WHERE s.name = 'OpenStreetMap'
  ORDER BY s.created_at NULLS LAST
  LIMIT 1
)
WHERE w.source_id IS NULL
  AND w.latitude IS NOT NULL
  AND w.longitude IS NOT NULL
  AND w.source_reference ILIKE '%OpenStreetMap via Photon%'
  AND w.external_source_id LIKE 'osm:%';
