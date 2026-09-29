-- Verified coordinates for Ömerli Dam structure / facility location.
-- Evidence cross-check:
--   OpenStreetMap way 221963283 via Mapcarta: https://mapcarta.com/es/13827910
--   Coordinate field on Wikipedia (article references DSI): https://fr.wikipedia.org/wiki/Barrage_d%27%C3%96merli
-- This is a dam/facility navigation point, NOT the reservoir centroid or shoreline access point.
-- Verified 2026-09-29. Idempotent data correction for duplicate source records.

begin;

update public.water_bodies
set latitude = 41.060925,
    longitude = 29.35799,
    source_reference = case
      when coalesce(source_reference, '') like '%Koordinat doğrulama: Ömerli Barajı gövde/tesis konumu%'
        then source_reference
      else concat_ws(' | ', nullif(source_reference, ''),
        'Koordinat doğrulama: Ömerli Barajı gövde/tesis konumu; https://mapcarta.com/es/13827910 (OSM way 221963283) ve https://fr.wikipedia.org/wiki/Barrage_d%27%C3%96merli (41.060925, 29.35799); doğrulama 2026-09-29')
    end,
    source_checked_at = now(),
    last_verified_at = now(),
    updated_at = now()
where id in (
  '1dd2cfbf-cc3b-4925-9ded-2f5430b84118',
  '2240563a-50ee-479f-a432-c744a8b80bfa',
  'afe835c0-d595-4ebc-b5b3-30a822e9a939',
  'cbe2b05e-f88d-4c1b-8599-d1ae18d81cce',
  'da2a589e-96e8-43ec-9737-a0068301eaf6'
);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name,
   candidate_latitude, candidate_longitude, match_confidence,
   evidence_url, checked_at, reviewer_notes, updated_at)
select w.id, 'manual', 'verified',
       'Ömerli Barajı — baraj gövdesi/tesis konumu',
       41.060925, 29.35799, 0.96,
       'https://mapcarta.com/es/13827910', now(),
       'Koordinat Mapcarta/OSM way 221963283 ile Wikipedia koordinat alanında çapraz kontrol edildi; iki kaynak yaklaşık aynı baraj gövdesi konumunu gösteriyor. Rezervuar sınırı/merkez noktası değil, navigasyon için baraj tesisi referans noktasıdır. Kaynak: https://fr.wikipedia.org/wiki/Barrage_d%27%C3%96merli',
       now()
from public.water_bodies w
where w.id in (
  '1dd2cfbf-cc3b-4925-9ded-2f5430b84118',
  '2240563a-50ee-479f-a432-c744a8b80bfa',
  'afe835c0-d595-4ebc-b5b3-30a822e9a939',
  'cbe2b05e-f88d-4c1b-8599-d1ae18d81cce',
  'da2a589e-96e8-43ec-9737-a0068301eaf6'
)
on conflict (water_body_id, provider) do update
set status = excluded.status,
    candidate_name = excluded.candidate_name,
    candidate_latitude = excluded.candidate_latitude,
    candidate_longitude = excluded.candidate_longitude,
    match_confidence = excluded.match_confidence,
    evidence_url = excluded.evidence_url,
    checked_at = excluded.checked_at,
    reviewer_notes = excluded.reviewer_notes,
    updated_at = now();

commit;
