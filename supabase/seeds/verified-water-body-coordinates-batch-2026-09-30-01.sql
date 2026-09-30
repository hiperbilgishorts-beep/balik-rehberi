-- Balık Rehberi coordinate batch 2026-09-30
-- Batch is intentionally limited to the one missing record that passed exact distinctive-name,
-- province, water-feature type, and OSM source checks. No guessed coordinates are included.
-- Coordinates are the general waterbody position, not fishing-access coordinates.
begin;

update public.water_bodies
set latitude = 40.1545552,
    longitude = 36.9199172,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap via Photon; exact distinctive alias Yusufoğlan Baraj Gölü matches Sivas-Yıldızeli Güneykaya (Yusufoğlan) Barajı; same province (Sivas); OSM water=reservoir feature way/100789873; general waterbody position, not fishing access. https://www.openstreetmap.org/way/100789873 | https://photon.komoot.io/api/?q=Goleti%20Sivas&limit=100'
where id = 'bc4d393e-6bbf-4337-b286-fed4a16c35fb'
  and (latitude is null or longitude is null);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude,
   provider_place_id, match_confidence, evidence_url, checked_at, reviewer_notes)
select
  'bc4d393e-6bbf-4337-b286-fed4a16c35fb',
  'openstreetmap',
  'verified',
  'Yusufoğlan Baraj Gölü',
  40.1545552,
  36.9199172,
  'way/100789873',
  0.98,
  'https://www.openstreetmap.org/way/100789873',
  now(),
  'Exact distinctive alias and province match; water=reservoir feature; general waterbody position only, not fishing access.'
where not exists (
  select 1 from public.water_body_location_checks
  where water_body_id = 'bc4d393e-6bbf-4337-b286-fed4a16c35fb'
    and provider = 'openstreetmap'
    and provider_place_id = 'way/100789873'
);

commit;
