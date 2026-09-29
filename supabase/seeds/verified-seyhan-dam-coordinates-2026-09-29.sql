-- Verified coordinates for Seyhan Dam structure / facility location.
-- Evidence cross-check:
--   OpenStreetMap dam feature way 26066190 via Mapcarta: https://mapcarta.com/12947670
--   Independent coordinate field: https://fr.wikipedia.org/wiki/Barrage_de_Seyhan (article references DSI)
-- OSM dam point 37.03719, 35.34058; second source 37.037657, 35.342288 (~160 m apart).
-- This is a dam-structure navigation point, NOT the reservoir centroid or shoreline access point.
-- Verified 2026-09-29. Idempotent data correction for duplicate source records.

begin;

update public.water_bodies
set latitude = 37.03719,
    longitude = 35.34058,
    source_reference = case
      when coalesce(source_reference, '') like '%Koordinat doğrulama: Seyhan Barajı gövde/tesis konumu%'
        then source_reference
      else concat_ws(' | ', nullif(source_reference, ''),
        'Koordinat doğrulama: Seyhan Barajı gövde/tesis konumu; https://mapcarta.com/12947670 (OSM way 26066190; 37.03719, 35.34058), çapraz kontrol: https://fr.wikipedia.org/wiki/Barrage_de_Seyhan (37.037657, 35.342288); doğrulama 2026-09-29')
    end,
    source_checked_at = now(),
    last_verified_at = now(),
    updated_at = now()
where id in (
  '2a32b12b-ec47-40cf-9f1c-0b9325b87315',
  'd24127e3-95c1-4025-8610-c17ed13b8cde'
);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name,
   candidate_latitude, candidate_longitude, match_confidence,
   evidence_url, checked_at, reviewer_notes, updated_at)
select w.id, 'manual', 'verified',
       'Seyhan Barajı — baraj gövdesi/tesis konumu',
       37.03719, 35.34058, 0.94,
       'https://mapcarta.com/12947670', now(),
       'OSM way 26066190 dam feature. Cross-check against https://fr.wikipedia.org/wiki/Barrage_de_Seyhan coordinate 37.037657, 35.342288 (about 160 m difference; likely different reference point on the dam/facility). Stored as dam-structure navigation point, not reservoir centroid or shoreline access point.',
       now()
from public.water_bodies w
where w.id in (
  '2a32b12b-ec47-40cf-9f1c-0b9325b87315',
  'd24127e3-95c1-4025-8610-c17ed13b8cde'
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
