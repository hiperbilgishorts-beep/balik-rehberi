-- Targeted Photon lookups: exact normalized name + exact province + compatible water feature.
-- 6 new records; general waterbody coordinates, not fishing access.
begin;
update public.sources set verification_status='verified',last_checked_at=now() where id='ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid;
with batch(target_id,latitude,longitude,candidate_name,osm_id,osm_type,source_url) as (values
('61000000-0000-4000-8000-000000000009'::uuid,38.0866423,36.7180603,'Adatepe Baraj Gölü',11165611::bigint,'R','https://photon.komoot.io/api/?q=Adatepe%20Baraj%20Golu%20Kahramanmaras&countrycode=TR&limit=5'),
('0ba4e586-dce4-4fb1-a981-0b8936ed0d6c'::uuid,37.6941019,38.1469158,'Çamgazi Barajı',195166884::bigint,'W','https://photon.komoot.io/api/?q=Camgazi%20Baraji%20Adiyaman&countrycode=TR&limit=5'),
('19d98b4d-f354-4e74-8a4c-7f3747d225c1'::uuid,37.8404343,37.6654195,'Çetintepe Barajı',856333506::bigint,'W','https://photon.komoot.io/api/?q=Cetintepe%20Baraji%20Adiyaman&countrycode=TR&limit=5'),
('da8fb1ce-aedd-4134-8eb0-04c2406eeb35'::uuid,38.9710446,30.900669,'Bayat Göleti',230492855::bigint,'W','https://photon.komoot.io/api/?q=Bayat%20Goleti%20Afyonkarahisar&countrycode=TR&limit=5'),
('d8fd1af0-4b7b-4179-8000-e2381558fdb2'::uuid,38.5745682,31.0228817,'Çay Barajı',956025632::bigint,'W','https://photon.komoot.io/api/?q=Cay%20Baraji%20Afyonkarahisar&countrycode=TR&limit=5'),
('88b4bf7b-e2b3-47f4-b370-dba08aa934e7'::uuid,38.5745682,31.0228817,'Çay Barajı',956025632::bigint,'W','https://photon.komoot.io/api/?q=Cay%20Baraji%20Afyonkarahisar&countrycode=TR&limit=5')
)
update public.water_bodies w set latitude=b.latitude,longitude=b.longitude,source_id='ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid,verification_level='B',verification_status='verified',source_checked_at=now(),last_verified_at=now(),source_reference=b.source_url||' | OpenStreetMap via Photon; targeted exact water-name + province match; general waterbody position, not fishing-access point.',external_source_id='osm:'||b.osm_id::text||':'||w.id::text from batch b where w.id=b.target_id and (w.latitude is null or w.longitude is null);
commit;
