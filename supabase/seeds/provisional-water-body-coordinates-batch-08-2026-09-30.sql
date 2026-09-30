-- Provisional general waterbody coordinates from OSM features with matching name stem and province.
-- Source labels the features as ponds/gölets while the inventory labels them as dams/baraj.
-- Coordinates are stored as pending (level D); they must not be treated as fully verified until the type/name discrepancy is resolved.
update public.water_bodies
set latitude = 38.3912267,
    longitude = 30.1611526,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'D',
    verification_status = 'pending',
    source_checked_at = now(),
    last_verified_at = null,
    source_reference = 'OpenStreetMap water feature candidate; name stem and province match, but source calls it Göleti while inventory calls it Baraj. Coordinates are provisional general location; type/name review required. https://www.openstreetmap.org/relation/5912592',
    external_source_id = 'osm:relation:5912592:record:4960787d-3191-4c71-8910-ca418752921f'
where id = '4960787d-3191-4c71-8910-ca418752921f';

update public.water_bodies
set latitude = 38.104404,
    longitude = 31.1500744,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'D',
    verification_status = 'pending',
    source_checked_at = now(),
    last_verified_at = null,
    source_reference = 'OpenStreetMap water feature candidate; name stem and province match, but source calls it Göleti while inventory calls it Baraj. Coordinates are provisional general location; type/name review required. https://www.openstreetmap.org/way/49056709',
    external_source_id = 'osm:way:49056709:record:32af0824-64e6-49c6-9b45-7c8007347aae'
where id = '32af0824-64e6-49c6-9b45-7c8007347aae';

update public.water_bodies
set latitude = 38.7213694,
    longitude = 29.49835,
    source_id = 'ca1ed63f-aab7-4f9d-83e0-401b383a824a',
    verification_level = 'D',
    verification_status = 'pending',
    source_checked_at = now(),
    last_verified_at = null,
    source_reference = 'OpenStreetMap water feature candidate; name stem and province match, but source calls it Göleti while inventory calls it Baraj. Coordinates are provisional general location; type/name review required. https://www.openstreetmap.org/way/143939950',
    external_source_id = 'osm:way:143939950:record:cacb9910-a33b-4c0f-84ac-9ae6afe0948b'
where id = 'cacb9910-a33b-4c0f-84ac-9ae6afe0948b';
