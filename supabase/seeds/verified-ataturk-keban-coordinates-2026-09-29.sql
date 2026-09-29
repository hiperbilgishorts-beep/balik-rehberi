-- Verified coordinates for Atatürk and Keban dam structures.
-- Atatürk:
--   OSM/Mapcarta dam point: https://mapcarta.com/29167556 (37.48049, 38.31764)
--   Global Energy Monitor plant point: https://www.gem.wiki/Ataturk_hydroelectric_plant (37.4819, 38.3189)
-- Keban:
--   OSM/Mapcarta way 28431893, waterway=dam: https://mapcarta.com/12962454 (38.80803, 38.75670)
--   Global Energy Monitor plant point: https://www.gem.wiki/Keban_hydroelectric_plant (38.8055, 38.7591)
-- These are structure/plant navigation references, NOT reservoir centroids or shoreline access points.
-- Verified 2026-09-29. Idempotent correction for named DSİ catalog records.

begin;

update public.water_bodies
set latitude = 37.48049,
    longitude = 38.31764,
    source_reference = concat_ws(' | ', nullif(source_reference, ''),
      'Koordinat doğrulama: Atatürk Barajı yapısı; Mapcarta/OSM https://mapcarta.com/29167556 (37.48049,38.31764); santral çapraz kontrolü Global Energy Monitor https://www.gem.wiki/Ataturk_hydroelectric_plant (37.4819,38.3189; farklı tesis noktası); doğrulama 2026-09-29'),
    source_checked_at = now(), last_verified_at = now(), updated_at = now()
where id = '189101a8-8814-4fa9-9d15-acfd5602e11b';

update public.water_bodies
set latitude = 38.80803,
    longitude = 38.7567,
    source_reference = concat_ws(' | ', nullif(source_reference, ''),
      'Koordinat doğrulama: Keban Barajı yapısı; Mapcarta/OSM way 28431893 https://mapcarta.com/12962454 (38.80803,38.75670); santral çapraz kontrolü Global Energy Monitor https://www.gem.wiki/Keban_hydroelectric_plant (38.8055,38.7591; farklı tesis noktası); doğrulama 2026-09-29'),
    source_checked_at = now(), last_verified_at = now(), updated_at = now()
where id = 'ed0d237b-4338-49c7-bfad-e96753989198';

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude,
   candidate_longitude, match_confidence, evidence_url, checked_at,
   reviewer_notes, updated_at)
values
('189101a8-8814-4fa9-9d15-acfd5602e11b','manual','verified',
 'Atatürk Barajı — baraj yapısı',37.48049,38.31764,0.95,
 'https://mapcarta.com/29167556',now(),
 'Mapcarta/OSM dam structure point. Global Energy Monitor lists 37.4819,38.3189 for the hydroelectric plant, a nearby but distinct feature. Coordinates are for dam structure navigation, not reservoir centroid or shore access.',now()),
('ed0d237b-4338-49c7-bfad-e96753989198','manual','verified',
 'Keban Barajı — baraj yapısı',38.80803,38.7567,0.95,
 'https://mapcarta.com/12962454',now(),
 'Mapcarta/OSM way 28431893 tagged waterway=dam. Global Energy Monitor lists 38.8055,38.7591 for the hydroelectric plant, a nearby but distinct feature. Coordinates are for dam structure navigation, not reservoir centroid or shore access.',now())
on conflict (water_body_id, provider) do update
set status=excluded.status, candidate_name=excluded.candidate_name,
    candidate_latitude=excluded.candidate_latitude,
    candidate_longitude=excluded.candidate_longitude,
    match_confidence=excluded.match_confidence, evidence_url=excluded.evidence_url,
    checked_at=excluded.checked_at, reviewer_notes=excluded.reviewer_notes,
    updated_at=now();

commit;
