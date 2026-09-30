-- Batch 04: exact waterbody name match with Roman-numeral normalization.
-- The OSM feature is the dam structure point, not a reservoir centroid or fishing-access point.
update public.water_bodies
set latitude = 40.0033593,
    longitude = 32.9306461,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid,
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap named dam feature; candidate=Çubuk I Barajı; exact province match and Roman numeral I = 1; general dam-structure location, not reservoir centroid or fishing access. https://www.openstreetmap.org/way/865584295',
    external_source_id = 'osm:W:865584295'
where id = '928cd5e3-0923-42e5-84af-4e5d0ed687b4'::uuid
  and name = 'Ankara-Çubuk 1 Barajı'
  and province_id = (select id from public.provinces where name = 'Ankara')
  and (latitude is null or longitude is null);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude, match_confidence, evidence_url, checked_at, reviewer_notes)
select '928cd5e3-0923-42e5-84af-4e5d0ed687b4'::uuid, 'openstreetmap', 'verified',
       'Çubuk I Barajı', 40.0033593, 32.9306461, 0.95,
       'https://www.openstreetmap.org/way/865584295', now(),
       'Exact same-province water feature; Roman numeral I matches database number 1. Dam-structure point only, not reservoir centroid or fishing-access point.'
where exists (
  select 1 from public.water_bodies
  where id = '928cd5e3-0923-42e5-84af-4e5d0ed687b4'::uuid
    and latitude = 40.0033593 and longitude = 32.9306461
)
on conflict do nothing;
