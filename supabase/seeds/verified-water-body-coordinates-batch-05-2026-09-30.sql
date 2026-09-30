-- Verified general dam-location refresh for the two Kahramanmaras records.
-- Exact waterway=dam name/province match in Photon/OSM; not fishing-access points.
-- Idempotent seed: updates only the listed water_bodies IDs.
update public.water_bodies
set latitude = 37.933544,
    longitude = 36.9700728,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap waterway=dam; exact name/province match via Photon; general dam location, not fishing-access point. https://www.openstreetmap.org/way/397040367',
    external_source_id = 'osm:way:397040367'
where id = '61000000-0000-4000-8000-000000000008';

update public.water_bodies
set latitude = 37.5007666,
    longitude = 36.5956565,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'OpenStreetMap waterway=dam; exact name/province match via Photon; general dam location, not fishing-access point. https://www.openstreetmap.org/way/128531818',
    external_source_id = 'osm:way:128531818'
where id = '61000000-0000-4000-8000-000000000010';
