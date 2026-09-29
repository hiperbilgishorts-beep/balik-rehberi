-- Balık Rehberi: exact OSM/Photon water-name + province matches.
-- 47 records; new general waterbody positions only, never fishing-access points.
-- Candidate selection requires normalized exact name, matching province, compatible water type, and Turkey coordinate bounds.
begin;
update public.sources set verification_status='verified', last_checked_at=now(), notes=coalesce(notes||E'\n','')||' Used for exact-name + province waterbody coordinate verification via Photon (OpenStreetMap).'
where id='ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid;
with batch(target_id,latitude,longitude,candidate_name,osm_id,osm_type,source_url) as (
 values
('5f32f07a-7184-48cc-aa47-b0ac71fbfd95'::uuid, 40.8459038, 35.8452262, 'Derinöz Baraj Gölü', 177035397::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('c96aed86-6e95-4fc3-a8ce-b7e97c7204d0'::uuid, 40.4121062, 32.3444172, 'Çamlıdere Baraj Gölü', 1319084::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('b6418481-cb98-4ca3-a404-1f5acad051af'::uuid, 39.3347342, 33.4643462, 'Kesikköprü Baraj Gölü', 2280078::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('47785761-daa2-467b-b1e0-b6ee260e541c'::uuid, 37.9065011, 27.7536568, 'İkizdere Baraj Gölü', 5297807::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('cfa8d7e3-0804-4261-b964-f8cf55bc67c5'::uuid, 37.9065011, 27.7536568, 'İkizdere Baraj Gölü', 5297807::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('eeee0960-95ea-41b8-a709-7cc3b5207d6d'::uuid, 37.7713224, 28.6079041, 'Karacasu Baraj Gölü', 18143910::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoir&countrycode=TR&limit=50'),
('c3432492-e07f-4533-9475-10ff52e71386'::uuid, 37.7713224, 28.6079041, 'Karacasu Baraj Gölü', 18143910::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoir&countrycode=TR&limit=50'),
('7571a949-58b8-473e-a494-2e2c2dee8434'::uuid, 39.4046758, 40.2968527, 'Kiğı Baraj Gölü', 10429420::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('3b2ed3ab-589a-4ec5-aa7a-f87f23f2dacb'::uuid, 37.2883505, 29.6053438, 'Belkaya Baraj Gölü', 179758265::bigint, 'W', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('9ed211ef-d065-4b44-9f81-8910fd5d73af'::uuid, 39.9998429, 28.813934, 'Çınarcık Baraj Gölü', 2297492::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('ff862228-9f84-4ec8-8e3a-24951d04a8ef'::uuid, 40.1737494, 25.8547127, 'Gökçeada Baraj Gölü', 221940242::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('4f5640bc-49e9-4599-9193-ae1d5947ee33'::uuid, 40.1737494, 25.8547127, 'Gökçeada Baraj Gölü', 221940242::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('81ca9e15-cae6-4880-b26d-676c665464ff'::uuid, 40.0809212, 34.9502408, 'Koçhisar Baraj Gölü', 17056938::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('52d2932c-bf26-4f00-802b-78988b51b47b'::uuid, 37.5945573, 28.9205788, 'Yenidere Baraj Gölü', 2400592::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('138e2b22-daa4-4f54-84af-3dbcea7d3308'::uuid, 37.5945573, 28.9205788, 'Yenidere Baraj Gölü', 2400592::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('6f08f13e-a467-4136-921e-60ed3beeef30'::uuid, 40.7751418, 26.3958063, 'Hamzadere Baraj Gölü', 4195201::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('d960fe71-7fb1-4485-b076-a463106f7ad9'::uuid, 40.7751418, 26.3958063, 'Hamzadere Baraj Gölü', 4195201::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('fd02b02e-350a-49a5-8916-74b683a0f7d3'::uuid, 40.7751418, 26.3958063, 'Hamzadere Baraj Gölü', 4195201::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('b9dc9a9b-e41b-4aad-9256-48cd26dbc880'::uuid, 41.8207483, 26.929743, 'Süloğlu Baraj Gölü', 3094970::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('17eefc33-721f-4c25-9008-844116b2026c'::uuid, 41.8207483, 26.929743, 'Süloğlu Baraj Gölü', 3094970::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('d6d6689e-b2c8-4964-aafe-f10ec5001e1e'::uuid, 41.8207483, 26.929743, 'Süloğlu Baraj Gölü', 3094970::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('67ddc4bb-aea2-41d8-93f5-d8091d9b55ad'::uuid, 36.8668273, 37.604456, 'Doğanpınar Baraj Gölü', 18988610::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoir&countrycode=TR&limit=50'),
('108521d0-c7d8-421c-a74e-a2cf42558c6a'::uuid, 37.3298671, 44.4394907, 'Beyyurdu Baraj Gölü', 1060499255::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('c37b936f-6ea2-488a-8ca0-d659756ba0e6'::uuid, 39.2362883, 27.3144526, 'Yortanlı Baraj Gölü', 2915598::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('5751445b-5d8a-4e96-b94a-27d9d2f08132'::uuid, 39.2362883, 27.3144526, 'Yortanlı Baraj Gölü', 2915598::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('a7f8fd8e-30c5-4341-ae7c-00691a2cd68d'::uuid, 37.6438857, 36.8044486, 'Kılavuzlu Baraj Gölü', 3989183::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('8b376d9f-3534-4912-b5d4-bd649b75928d'::uuid, 41.302364, 33.7415386, 'Karaçomak Baraj Gölü', 68448801::bigint, 'W', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('84dc4613-84bb-48d0-bbe6-0a9281577904'::uuid, 39.6455964, 33.4887725, 'Kapulukaya Baraj Gölü', 1395031::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('6d048c15-6a4e-484f-af0f-d473723d5be4'::uuid, 41.770103, 27.3320696, 'Kırklareli Baraj Gölü', 1318075::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('92899b41-2c1b-4e1e-8e93-639fd860c72d'::uuid, 41.770103, 27.3320696, 'Kırklareli Baraj Gölü', 1318075::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('c5498076-e1ed-4269-8fbe-2490dfd00399'::uuid, 37.778394, 31.5163297, 'Beyşehir Gölü', 207124::bigint, 'R', 'https://photon.komoot.io/api/?q=lake&countrycode=TR&limit=50'),
('3a0ff1ed-28ba-4a29-9a20-593f4cb123f4'::uuid, 37.9286305, 32.3969349, 'Sille Baraj Gölü', 4015034::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('8a8fe02e-e04e-4f7c-b5c9-b62ab2b9f2e9'::uuid, 38.7605121, 28.0794632, 'Gördes Baraj Gölü', 2922298::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('f90176bf-18c0-4e65-a8fa-a18124ce9c99'::uuid, 38.7605121, 28.0794632, 'Gördes Baraj Gölü', 2922298::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('3b22ec7a-9ae6-44a4-a69d-aa4bb283b3d9'::uuid, 39.2951984, 27.5591292, 'Sevişler Baraj Gölü', 1319236::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('23e6b1a9-db57-4699-a896-a11f50defc8a'::uuid, 39.2951984, 27.5591292, 'Sevişler Baraj Gölü', 1319236::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('2be3f61d-e68c-4d14-8e9c-946cfedb9ee2'::uuid, 36.8389566, 34.1619102, 'Sorgun Baraj Gölü', 1504096288::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('1d503d05-ccf8-4a96-a234-e480a4166aed'::uuid, 39.0575028, 41.9513021, 'Alpaslan-1 Baraj Gölü', 2436188::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('0b3dd4e3-fc43-4216-8b17-4b885ff267c6'::uuid, 39.1997825, 34.74282, 'Doyduk Baraj Gölü', 1244038240::bigint, 'W', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('7e7bf96a-be7b-4281-89b2-f19f78ab1d45'::uuid, 41.3273619, 34.7142091, 'Saraydüzü Baraj Gölü', 2928783::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('78e6c930-3891-44aa-85c1-1565f826e3d5'::uuid, 39.8838439, 38.169687, 'İmranlı Barajı Gölü', 1507009::bigint, 'R', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50'),
('5decbd96-a541-486f-9300-9813c7abd492'::uuid, 40.8691459, 27.3951306, 'Naipköy Baraj Gölü', 965616969::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('3b39284a-c2d0-463f-8049-064f6bb6efbb'::uuid, 40.8691459, 27.3951306, 'Naipköy Baraj Gölü', 965616969::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('0f969019-bbcf-43df-a457-d5c69f109bc5'::uuid, 40.8691459, 27.3951306, 'Naipköy Baraj Gölü', 965616969::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('4b6a8689-471e-4260-95c6-16ecbf798594'::uuid, 40.8483506, 39.6983978, 'Atasu Baraj Gölü', 347293897::bigint, 'W', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('33a4e275-f1f4-4b82-98d5-ab5affaf4e43'::uuid, 39.0468437, 39.5260027, 'Uzunçayır Baraj Gölü', 7757527::bigint, 'R', 'https://photon.komoot.io/api/?q=baraj gölü&countrycode=TR&limit=50'),
('cce4b780-b870-4590-a276-a34c8058f857'::uuid, 40.5954457, 29.1981162, 'Gökçe Baraj Gölü', 221876484::bigint, 'W', 'https://photon.komoot.io/api/?q=reservoirs&countrycode=TR&limit=50')
)
update public.water_bodies w
set latitude=b.latitude,
    longitude=b.longitude,
    source_id='ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid,
    verification_level='B',
    verification_status='verified',
    source_checked_at=now(),
    last_verified_at=now(),
    source_reference=b.source_url||' | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.',
    external_source_id='osm:'||b.osm_id::text||':'||w.id::text
from batch b
where w.id=b.target_id and (w.latitude is null or w.longitude is null);
commit;
