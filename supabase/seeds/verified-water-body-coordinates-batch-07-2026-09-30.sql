-- Verified general dam location for two duplicate Manisa water-body inventory rows.
-- OSM waterway=dam feature name Davutlar Barajı; province and name suffix match.
-- These are general location pins, not fishing-access points.
update public.water_bodies
set latitude = 38.798012,
    longitude = 27.3569172,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap waterway=dam; candidate Davutlar Barajı matches name suffix and Manisa province; general dam location, not fishing-access point. https://www.openstreetmap.org/way/1118709265',
    external_source_id = 'osm:way:1118709265:record:5927e818-806d-4613-bb77-f82b9b1b5794'
where id = '5927e818-806d-4613-bb77-f82b9b1b5794';

update public.water_bodies
set latitude = 38.798012,
    longitude = 27.3569172,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap waterway=dam; candidate Davutlar Barajı matches name suffix and Manisa province; general dam location, not fishing-access point. https://www.openstreetmap.org/way/1118709265',
    external_source_id = 'osm:way:1118709265:record:a5ce82c4-c9bf-4131-8cfc-4d78a7ff4527'
where id = 'a5ce82c4-c9bf-4131-8cfc-4d78a7ff4527';
