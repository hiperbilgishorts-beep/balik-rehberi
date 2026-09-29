-- Verified general waterbody coordinates, batch 3 (province + feature-class checked).
-- Coordinates indicate the waterbody's general position, not fishing access.
-- Source: GeoNames individual feature pages; only exact-name/province-compatible rows included.
begin;

update public.water_bodies set
  latitude = 39.993045, longitude = 26.862626,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Küçüklü Göleti; https://www.geonames.org/10410020/kuecueklue-goeleti.html',
  external_source_id = 'geonames:10410020:7ec507e6-e5bd-4257-ad0f-adc2eaa281c4'
where id = '7ec507e6-e5bd-4257-ad0f-adc2eaa281c4';

update public.water_bodies set
  latitude = 40.276358, longitude = 27.025233,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Kozçeşme Göleti; https://www.geonames.org/10409999/kozcesme-goeleti.html',
  external_source_id = 'geonames:10409999:88b949e2-7210-4d42-8b11-bd8073bae208'
where id = '88b949e2-7210-4d42-8b11-bd8073bae208';

update public.water_bodies set
  latitude = 39.993045, longitude = 26.862626,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Küçüklü Göleti; https://www.geonames.org/10410020/kuecueklue-goeleti.html',
  external_source_id = 'geonames:10410020:47eb4aab-ae4f-4d96-aeac-e085c390edf4'
where id = '47eb4aab-ae4f-4d96-aeac-e085c390edf4';

update public.water_bodies set
  latitude = 39.993045, longitude = 26.862626,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Küçüklü Göleti; https://www.geonames.org/10410020/kuecueklue-goeleti.html',
  external_source_id = 'geonames:10410020:fe0c1966-0406-413f-bbbb-5161ae70eada'
where id = 'fe0c1966-0406-413f-bbbb-5161ae70eada';

update public.water_bodies set
  latitude = 40.436443, longitude = 26.553222,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Fındıklı Göleti; https://www.geonames.org/10409941/findikli-goeleti.html',
  external_source_id = 'geonames:10409941:ce96048e-c384-4f7f-a998-e66b0a5b1ca5'
where id = 'ce96048e-c384-4f7f-a998-e66b0a5b1ca5';

update public.water_bodies set
  latitude = 39.94944, longitude = 27.215544,
  source_id = '0792edf5-4ef2-4c18-8c6c-1eae2cda306c',
  verification_level = 'B', verification_status = 'verified',
  source_checked_at = now(), last_verified_at = now(),
  source_reference = 'GeoNames exact waterbody-name match; province cross-check: Çanakkale; candidate=Torhasan Göleti; https://www.geonames.org/10410054/torhasan-goeleti.html',
  external_source_id = 'geonames:10410054:869b480a-7411-44b7-b45c-85df5e715c1c'
where id = '869b480a-7411-44b7-b45c-85df5e715c1c';

commit;
