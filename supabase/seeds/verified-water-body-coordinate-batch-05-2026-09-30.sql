-- Batch 05: named water-feature matches from OpenStreetMap/Photon and GeoNames.
-- All points indicate the general waterbody/dam feature, not fishing access.
with input(id, latitude, longitude, source_id, external_source_id, source_reference, evidence_url, candidate_name, confidence, provider, note) as (
  values
    ('9de19079-96e8-4370-bf77-6406e9e8d7c7'::uuid, 38.4032684, 34.1539029, 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid, 'osm:R:2057693', 'OpenStreetMap named reservoir feature; candidate=Mamasun Baraj Gölü; same province and reservoir class; spelling variant Mamasun/Mamasın; general waterbody location, not fishing access. https://www.openstreetmap.org/relation/2057693', 'https://www.openstreetmap.org/relation/2057693', 'Mamasun Baraj Gölü', 0.90, 'openstreetmap', 'Mamasun/Mamasın spelling variant; same province and water class.'),
    ('bc607bf6-de29-4510-b19e-97b025825082'::uuid, 37.972885, 40.056244, '0792edf5-4ef2-4c18-8c6c-1eae2cda306c'::uuid, 'geonames:448098:bc607bf6-de29-4510-b19e-97b025825082', 'GeoNames reservoir feature; candidate=Gözegölü Sulama Göleti; same province and name variant; general waterbody location, not fishing access. https://www.geonames.org/448098/goezegoelue-sulama-goeleti.html', 'https://www.geonames.org/448098/goezegoelue-sulama-goeleti.html', 'Gözegölü Sulama Göleti', 0.88, 'manual', 'Gözegöl/Gözegölü spelling variant; same province and reservoir class.'),
    ('4d10d5c0-ead4-466f-b53c-529a634334c8'::uuid, 40.6256787, 26.3478866, 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid, 'osm:W:312822504', 'OpenStreetMap named reservoir feature; candidate=Karaincirli Köyü Sulama ve Erozyon Göleti; distinctive name and province match; general waterbody location, not fishing access. https://www.openstreetmap.org/way/312822504', 'https://www.openstreetmap.org/way/312822504', 'Karaincirli Köyü Sulama ve Erozyon Göleti', 0.92, 'openstreetmap', 'Distinctive waterbody name and province match.'),
    ('3951235b-1ab3-40c0-ac3d-0345571be0f0'::uuid, 40.0288333, 32.3638025, 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid, 'osm:W:1384798635', 'OpenStreetMap named reservoir feature; candidate=Başayaş Sulama Göleti; same province and distinctive name; database calls it Baraj while source calls it Göleti; general waterbody location, not fishing access. https://www.openstreetmap.org/way/1384798635', 'https://www.openstreetmap.org/way/1384798635', 'Başayaş Sulama Göleti', 0.88, 'openstreetmap', 'Same province/name stem; Baraj/Göleti naming difference retained in source notes.'),
    ('8d1b687c-2dae-4a3b-97b7-b199f8b1dbf2'::uuid, 37.5314581, 41.8461144, 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid, 'osm:W:288882668', 'OpenStreetMap named dam structure; candidate=Ilısu Barajı; same province Mardin and distinctive name match. This is the dam-structure point, not the reservoir centroid or fishing access. https://www.openstreetmap.org/way/288882668', 'https://www.openstreetmap.org/way/288882668', 'Ilısu Barajı', 0.93, 'openstreetmap', 'Dam structure point; reservoir extends across provinces.'),
    ('ae6b1bd8-5597-4809-a275-f9a1964a8a15'::uuid, 37.7338504, 38.3947454, 'ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid, 'osm:W:40119885', 'OpenStreetMap named reservoir feature; candidate=Karahüyük Göleti; same province and spelling variant Karahöyük/Karahüyük; general waterbody location, not fishing access. https://www.openstreetmap.org/way/40119885', 'https://www.openstreetmap.org/way/40119885', 'Karahüyük Göleti', 0.88, 'openstreetmap', 'Karahöyük/Karahüyük spelling variant; same province and reservoir class.')
)
update public.water_bodies w
set latitude = i.latitude,
    longitude = i.longitude,
    source_id = i.source_id,
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = i.source_reference,
    external_source_id = i.external_source_id
from input i
where w.id = i.id
  and (w.latitude is null or w.longitude is null);

with input(id, latitude, longitude, evidence_url, candidate_name, confidence, provider, note) as (
  values
    ('9de19079-96e8-4370-bf77-6406e9e8d7c7'::uuid, 38.4032684, 34.1539029, 'https://www.openstreetmap.org/relation/2057693', 'Mamasun Baraj Gölü', 0.90, 'openstreetmap', 'Mamasun/Mamasın spelling variant; same province and water class.'),
    ('bc607bf6-de29-4510-b19e-97b025825082'::uuid, 37.972885, 40.056244, 'https://www.geonames.org/448098/goezegoelue-sulama-goeleti.html', 'Gözegölü Sulama Göleti', 0.88, 'manual', 'Gözegöl/Gözegölü spelling variant; same province and reservoir class.'),
    ('4d10d5c0-ead4-466f-b53c-529a634334c8'::uuid, 40.6256787, 26.3478866, 'https://www.openstreetmap.org/way/312822504', 'Karaincirli Köyü Sulama ve Erozyon Göleti', 0.92, 'openstreetmap', 'Distinctive waterbody name and province match.'),
    ('3951235b-1ab3-40c0-ac3d-0345571be0f0'::uuid, 40.0288333, 32.3638025, 'https://www.openstreetmap.org/way/1384798635', 'Başayaş Sulama Göleti', 0.88, 'openstreetmap', 'Same province/name stem; Baraj/Göleti naming difference retained in source notes.'),
    ('8d1b687c-2dae-4a3b-97b7-b199f8b1dbf2'::uuid, 37.5314581, 41.8461144, 'https://www.openstreetmap.org/way/288882668', 'Ilısu Barajı', 0.93, 'openstreetmap', 'Dam structure point; reservoir extends across provinces.'),
    ('ae6b1bd8-5597-4809-a275-f9a1964a8a15'::uuid, 37.7338504, 38.3947454, 'https://www.openstreetmap.org/way/40119885', 'Karahüyük Göleti', 0.88, 'openstreetmap', 'Karahöyük/Karahüyük spelling variant; same province and reservoir class.')
)
insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude, match_confidence, evidence_url, checked_at, reviewer_notes)
select i.id, i.provider, 'verified', i.candidate_name, i.latitude, i.longitude, i.confidence, i.evidence_url, now(), i.note
from input i
join public.water_bodies w on w.id = i.id
where w.latitude = i.latitude and w.longitude = i.longitude
on conflict do nothing;
