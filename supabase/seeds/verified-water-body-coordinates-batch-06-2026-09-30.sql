-- Verified general waterbody location for Edirne-Keşan Çeltik Göleti.
-- GeoNames feature class is lake; exact name stem and province match.
-- General waterbody location only, not fishing-access point.
update public.water_bodies
set latitude = 40.766667,
    longitude = 26.183333,
    source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
    verification_level = 'B',
    verification_status = 'verified',
    source_checked_at = now(),
    last_verified_at = now(),
    source_reference = 'GeoNames lake feature; exact name stem and Edirne province match; general waterbody location, not fishing-access point. https://www.geonames.org/749346/celtik-goelue.html',
    external_source_id = 'geonames:749346'
where id = 'b686de50-086c-4cd0-b47e-441760da07d8';
