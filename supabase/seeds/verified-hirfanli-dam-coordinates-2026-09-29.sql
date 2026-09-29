-- Verified coordinate for Hirfanlı Dam structure.
-- OSM/Mapcarta dam feature way 170349895: https://mapcarta.com/12969876 (39.27338, 33.51864)
-- Independent plant coordinate from Global Energy Monitor: https://www.gem.wiki/Hirfanli_hydroelectric_plant (39.2731, 33.5184)
-- These are structure/plant references, NOT the reservoir centroid or shoreline access point.
-- Verified 2026-09-29; idempotent correction for the DSİ catalog row.

begin;

update public.water_bodies
set latitude = 39.27338,
    longitude = 33.51864,
    source_reference = concat_ws(' | ', nullif(source_reference, ''),
      'Koordinat doğrulama: Hirfanlı Barajı yapısı; Mapcarta/OSM way 170349895 https://mapcarta.com/12969876 (39.27338,33.51864); santral çapraz kontrolü Global Energy Monitor https://www.gem.wiki/Hirfanli_hydroelectric_plant (39.2731,33.5184; farklı tesis noktası); doğrulama 2026-09-29'),
    source_checked_at = now(), last_verified_at = now(), updated_at = now()
where id = 'a7783bec-7f5e-4381-8c1a-42afa219c3b5';

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude,
   candidate_longitude, match_confidence, evidence_url, checked_at,
   reviewer_notes, updated_at)
values
('a7783bec-7f5e-4381-8c1a-42afa219c3b5','manual','verified',
 'Hirfanlı Barajı — baraj yapısı',39.27338,33.51864,0.97,
 'https://mapcarta.com/12969876',now(),
 'Mapcarta/OSM way 170349895 tagged waterway=dam. Global Energy Monitor lists 39.2731,33.5184 for the hydroelectric plant, very close but a distinct facility reference. Coordinates are for dam structure navigation, not reservoir centroid or shore access.',now())
on conflict (water_body_id, provider) do update
set status=excluded.status, candidate_name=excluded.candidate_name,
    candidate_latitude=excluded.candidate_latitude,
    candidate_longitude=excluded.candidate_longitude,
    match_confidence=excluded.match_confidence, evidence_url=excluded.evidence_url,
    checked_at=excluded.checked_at, reviewer_notes=excluded.reviewer_notes,
    updated_at=now();

commit;
