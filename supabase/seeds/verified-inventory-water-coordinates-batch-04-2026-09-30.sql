-- Batch 04 (3 records): exact normalized name + exact province matches from
-- Türkiye Barajlar Envanteri public mapData (https://turkiyebarajlar.com/envanter).
-- Coordinates are general map points, not fishing access points.
-- This inventory contains many rounded/reused provincial-center coordinates; only
-- unique coordinate pairs with >=4 decimal places were selected in this batch.
-- Records remain pending independent verification; do not treat as verified fishing access.

WITH input(id, latitude, longitude, source_url, source_name) AS (
  VALUES
    ('18c9e238-e135-482c-bb49-88095a0a3552'::uuid, 41.3667, 33.7667, 'https://turkiyebarajlar.com/envanter-detay/kosencayiri', 'Kösençayırı'),
    ('6edac951-9c72-40b2-ae3c-b654e9fd0f05'::uuid, 40.9833, 27.4833, 'https://turkiyebarajlar.com/envanter-detay/inanli', 'İnanlı'),
    ('db8e5a39-6384-4f03-a2b6-17d44f345a37'::uuid, 38.6667, 29.4167, 'https://turkiyebarajlar.com/envanter-detay/ahmetler', 'Ahmetler')
),
updated AS (
  UPDATE public.water_bodies w
  SET latitude = i.latitude,
      longitude = i.longitude,
      source_id = '0df181f9-ca00-4c81-a964-7699e713fa29'::uuid,
      verification_level = 'C',
      verification_status = 'pending',
      source_checked_at = now(),
      last_verified_at = NULL,
      coordinate_confidence_grade = 'C',
      coordinate_confidence_note = 'Exact normalized waterbody name and province match in a secondary public dam inventory. Coordinate is a general map point; independent confirmation remains pending.',
      source_reference = 'Türkiye Barajlar Envanteri mapData; exact normalized name and province match; independent verification pending; general waterbody location only. ' || i.source_url,
      external_source_id = 'turkiyebarajlar:' || lower(regexp_replace(i.source_name, '[^a-zA-Z0-9]+', '-', 'g')) || ':' || w.id::text
  FROM input i
  WHERE w.id = i.id
    AND w.latitude IS NULL AND w.longitude IS NULL
  RETURNING w.id, w.name, w.latitude, w.longitude, w.source_reference
)
INSERT INTO public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude,
   match_confidence, evidence_url, checked_at, reviewer_notes)
SELECT u.id, 'manual', 'pending', i.source_name, u.latitude, u.longitude,
       0.75, i.source_url, now(),
       'Exact normalized name and province match from a secondary dam inventory. General map point only; independent verification pending.'
FROM updated u
JOIN input i ON i.id = u.id
ON CONFLICT DO NOTHING;
