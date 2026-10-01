-- Olta Atlası mera general-coordinate batch 08 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('0677ef3a-586c-45e8-a63b-5be08b2a0b6e'::uuid,'ulusal-duzce-buyuk-melen-cayi','Büyük Melen Çayı','Düzce',40.9834729,31.0052168,'https://oltaatlasi.com/meralar/ulusal-duzce-buyuk-melen-cayi/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('5730eeca-2537-4269-a23e-7f354d0c8742'::uuid,'ankara-500km-aydin-buyuk-menderes','Büyük Menderes','Aydın',37.8694134,28.6661796,'https://oltaatlasi.com/meralar/ankara-500km-aydin-buyuk-menderes/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('6d0c5268-d6a1-465b-8a5d-836acd1fd8c6'::uuid,'ulusal-istanbul-buyukcekmece-golu','Büyükçekmece Gölü','İstanbul',41.0647707,28.5580524,'https://oltaatlasi.com/meralar/ulusal-istanbul-buyukcekmece-golu/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('f31cf893-4823-4a15-b5d6-42898c670d72'::uuid,'buyukcekmece-sahili','Büyükçekmece Sahili','İstanbul',41.018,28.582,'https://oltaatlasi.com/meralar/buyukcekmece-sahili/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('1479837f-e5ec-4531-bd26-3d107920194e'::uuid,'ankara-500km-bilecik-buyukelmali-goleti','Büyükelmalı Göleti','Bilecik',40.0553994,29.8169157,'https://oltaatlasi.com/meralar/ankara-500km-bilecik-buyukelmali-goleti/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('c1a64486-7e57-4232-9d39-bed023589a15'::uuid,'ankara-500km-bolu-buyukgol','Büyükgöl','Bolu',40.9431548,31.7459969,'https://oltaatlasi.com/meralar/ankara-500km-bolu-buyukgol/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('3e77b6d7-0b97-46c9-afc2-2320a32f9cfe'::uuid,'ulusal-bursa-buyukorhan-baraj-golu','Büyükorhan Baraj Gölü','Bursa',39.783128,28.9227203,'https://oltaatlasi.com/meralar/ulusal-bursa-buyukorhan-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('3968ff78-5474-4a92-a600-986fd8032032'::uuid,'ankara-500km-tekirdag-buzagi-goleti','Buzağı Göleti','Tekirdağ',41.3445384,27.8940024,'https://oltaatlasi.com/meralar/ankara-500km-tekirdag-buzagi-goleti/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('3bbb52d2-3625-4b06-9894-c3f7d02b2c57'::uuid,'caddebostan-kamusal-sahil-hatti','Caddebostan Kamusal Sahil Hattı','İstanbul',40.9622,29.0622,'https://oltaatlasi.com/meralar/caddebostan-kamusal-sahil-hatti/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('b812be26-208e-4c69-b648-62efb6408abd'::uuid,'kocaeli-izmit-cagirgan-goleti','Çağırgan Göleti','Kocaeli',40.90723,29.96139,'https://oltaatlasi.com/meralar/kocaeli-izmit-cagirgan-goleti/','2026-09-30 15:07:07.329215+00'::timestamptz),
    ('fccb1cb6-f619-4526-a5e7-16e48f5ed42e'::uuid,'ankara-500km-kirsehir-cagirkan-goleti','Çağırkan Göleti','Kırşehir',39.3363768,33.8159289,'https://oltaatlasi.com/meralar/ankara-500km-kirsehir-cagirkan-goleti/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('a14ead19-9636-4c65-b201-67faf1c92a11'::uuid,'ankara-500km-yalova-caglayan-deresi','Çağlayan Deresi','Yalova',40.588402,29.1754035,'https://oltaatlasi.com/meralar/ankara-500km-yalova-caglayan-deresi/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('c92632ff-ea5d-4521-937c-430cbd60ec5a'::uuid,'cakirli-iznik-golu-piknik-sahili','Çakırlı İznik Gölü Piknik Sahili','Bursa',40.5005,29.4515,'https://oltaatlasi.com/meralar/cakirli-iznik-golu-piknik-sahili/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('9feed925-d6e5-4b87-b85b-83d85c86db5d'::uuid,'ankara-500km-ordu-calis-deresi','Çalış Deresi','Ordu',41.0180689,37.6035603,'https://oltaatlasi.com/meralar/ankara-500km-ordu-calis-deresi/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('f12b15ae-8a87-4964-9110-9f29b1e00414'::uuid,'ankara-500km-canakkale-calkoy-goleti','Çalköy Göleti','Çanakkale',39.9872024,27.1350313,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-calkoy-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('7892538e-1cb4-4d6f-87bc-f3908501a5a9'::uuid,'ankara-500km-bilecik-calti-baraj-golu','Çaltı Baraj Gölü','Bilecik',40.0399254,30.273995,'https://oltaatlasi.com/meralar/ankara-500km-bilecik-calti-baraj-golu/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('84b80d80-b34a-493a-9408-6cbfd23a997d'::uuid,'ankara-500km-sivas-calti-cayi','Çaltı Çayı','Sivas',39.3940939,38.1498986,'https://oltaatlasi.com/meralar/ankara-500km-sivas-calti-cayi/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('0bdc8b5a-1326-4110-91d0-0daeb251c2f2'::uuid,'ulusal-adiyaman-camgazi-baraj-golu','Çamgazi Baraj Gölü','Adıyaman',37.7001716,38.1547359,'https://oltaatlasi.com/meralar/ulusal-adiyaman-camgazi-baraj-golu/','2026-09-30 15:07:27.714346+00'::timestamptz),
    ('84c193c6-9ced-4f7c-9e9d-d4011de709bd'::uuid,'ankara-500km-aksaray-camili-goleti','Camili Göleti','Aksaray',38.864065,33.9475734,'https://oltaatlasi.com/meralar/ankara-500km-aksaray-camili-goleti/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('7cce4012-b879-4a92-8e37-55a2f19cfc1b'::uuid,'ulusal-balikesir-camkoy-baraj-golu','Çamköy Baraj Gölü','Balıkesir',39.4632617,28.1654316,'https://oltaatlasi.com/meralar/ulusal-balikesir-camkoy-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('6c54c0e1-5977-4e47-a9a3-af9fc0fb7308'::uuid,'ankara-500km-kayseri-camlica-ii-goleti','Çamlıca II Göleti','Kayseri',38.0227618,35.5040681,'https://oltaatlasi.com/meralar/ankara-500km-kayseri-camlica-ii-goleti/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('398b3d21-9c18-4aa9-924a-9189c2f0ae53'::uuid,'ankara-500km-kayseri-camlica-iii-goleti','Çamlıca III Göleti','Kayseri',37.8951636,35.5028786,'https://oltaatlasi.com/meralar/ankara-500km-kayseri-camlica-iii-goleti/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('e93cff08-f84c-44e6-876d-46b7430d5a62'::uuid,'ulusal-ankara-camlidere-baraj-golu','Çamlıdere Baraj Gölü','Ankara',40.4121062,32.3444172,'https://oltaatlasi.com/meralar/ulusal-ankara-camlidere-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('cb6bf90e-b476-44e2-abcc-ec6816dd85d9'::uuid,'ankara-500km-burdur-camlik-baraji','Çamlık Barajı','Burdur',37.4642118,30.7192648,'https://oltaatlasi.com/meralar/ankara-500km-burdur-camlik-baraji/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('56fed108-331c-41ec-bd48-cc0472e14e25'::uuid,'ankara-500km-duzce-camlipinar','Çamlıpınar','Düzce',40.7208464,31.3831226,'https://oltaatlasi.com/meralar/ankara-500km-duzce-camlipinar/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('a2deed9b-efa1-4931-ac6d-7c17f0e8e98d'::uuid,'ankara-500km-manisa-camonu-baraj-golu','Çamönü Baraj Gölü','Manisa',38.952282,27.9092744,'https://oltaatlasi.com/meralar/ankara-500km-manisa-camonu-baraj-golu/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('aa1c6f46-300b-462d-83e0-c3bc6be4ba0e'::uuid,'ankara-500km-denizli-camrak-goleti','Çamrak Göleti','Denizli',38.2285217,28.977178,'https://oltaatlasi.com/meralar/ankara-500km-denizli-camrak-goleti/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('4a49f23d-c3d3-423d-93bc-7331b50b0493'::uuid,'ankara-500km-tokat-canakci-deresi','Çanakçı Deresi','Tokat',40.586253,36.9449597,'https://oltaatlasi.com/meralar/ankara-500km-tokat-canakci-deresi/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('a2145939-c36b-408a-88e8-69b39e5250df'::uuid,'ankara-500km-kahramanmaras-cardak-korkmaz-goleti','Çardak Korkmaz Göleti','Kahramanmaraş',38.0973842,36.801777,'https://oltaatlasi.com/meralar/ankara-500km-kahramanmaras-cardak-korkmaz-goleti/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('c2e19edb-2cb5-4862-b821-11bca65fa16b'::uuid,'ankara-500km-aydin-cariklar-goleti','Çarıklar Göleti','Aydın',37.9373894,27.6751116,'https://oltaatlasi.com/meralar/ankara-500km-aydin-cariklar-goleti/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('22863324-310f-41ef-a6ef-0979cf14113f'::uuid,'ankara-500km-isparta-cariksaraylar-baraj-golu','Çarıksaraylar Baraj Gölü','Isparta',38.1150413,31.4351337,'https://oltaatlasi.com/meralar/ankara-500km-isparta-cariksaraylar-baraj-golu/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('b14a0039-9ea8-4c30-95b9-28890de911ce'::uuid,'ankara-500km-balikesir-carkaca-goleti','Çarkaca göleti','Balıkesir',39.4760794,27.4246831,'https://oltaatlasi.com/meralar/ankara-500km-balikesir-carkaca-goleti/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('6a47fc52-882f-483b-9f7d-c5633f2a53b6'::uuid,'ankara-500km-konya-carsamba-cayi','Çarşamba Çayı','Konya',37.369728,32.4782451,'https://oltaatlasi.com/meralar/ankara-500km-konya-carsamba-cayi/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('59770fde-0384-4118-bc5f-aa210e6f86fa'::uuid,'ulusal-adiyaman-cat-baraj-golu','Çat Baraj Gölü','Adıyaman',38.0868721,38.2994193,'https://oltaatlasi.com/meralar/ulusal-adiyaman-cat-baraj-golu/','2026-09-30 15:07:27.714346+00'::timestamptz),
    ('5c799f96-9e77-4359-a8f2-70ca68bbf8ad'::uuid,'ankara-500km-kastamonu-catak-baraj-golu','Çatak Baraj Gölü','Kastamonu',41.7828415,33.6689104,'https://oltaatlasi.com/meralar/ankara-500km-kastamonu-catak-baraj-golu/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('39f44488-21e0-4e74-b94b-84c39a47885d'::uuid,'ankara-500km-corum-catak-goleti','Çatak Göleti','Çorum',40.2097825,35.0166514,'https://oltaatlasi.com/meralar/ankara-500km-corum-catak-goleti/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('ca7670be-d796-422b-a87d-95e5b43d0bde'::uuid,'ankara-500km-giresun-catal-gol','Çatal Göl','Giresun',40.2831445,38.4560103,'https://oltaatlasi.com/meralar/ankara-500km-giresun-catal-gol/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('c99cb56a-76f4-455c-8954-5bfe453f5a82'::uuid,'ankara-500km-izmir-catal-golu','Çatal Gölü','İzmir',37.9920789,27.3192987,'https://oltaatlasi.com/meralar/ankara-500km-izmir-catal-golu/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('0c6d4d12-6f9a-4140-bf08-79b28fa765c8'::uuid,'ulusal-adana-catalan-baraj-golu','Çatalan Baraj Gölü','Adana',37.2636119,35.3588192,'https://oltaatlasi.com/meralar/ulusal-adana-catalan-baraj-golu/','2026-09-30 15:07:27.714346+00'::timestamptz),
    ('5f6b0c9d-038f-4c03-8592-0e650394e605'::uuid,'ankara-500km-balikesir-cataldag-goleti','Çataldağ Göleti','Balıkesir',39.8744447,28.268431,'https://oltaatlasi.com/meralar/ankara-500km-balikesir-cataldag-goleti/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('f94394be-5005-4979-9a9c-7c0b55505852'::uuid,'ankara-500km-adiyaman-cataltepe-goleti','Çataltepe Göleti','Adıyaman',37.7452974,38.5862966,'https://oltaatlasi.com/meralar/ankara-500km-adiyaman-cataltepe-goleti/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('de37c017-c8a4-4b5e-8e37-2b929730e5bd'::uuid,'ankara-500km-aksaray-catin-goleti','Çatin Göleti','Aksaray',38.6532481,34.1375666,'https://oltaatlasi.com/meralar/ankara-500km-aksaray-catin-goleti/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('3b1cc94a-6115-4177-8d3c-4de8638c211d'::uuid,'ulusal-eskisehir-catoren-baraj-golu','Çatören Baraj Gölü','Eskişehir',39.3022912,30.5786849,'https://oltaatlasi.com/meralar/ulusal-eskisehir-catoren-baraj-golu/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('ca9931d2-c94b-4614-9de1-44f8c38111a5'::uuid,'ulusal-kutahya-cavdarhisar-baraj-golu','Çavdarhisar Baraj Gölü','Kütahya',39.1617412,29.546811,'https://oltaatlasi.com/meralar/ulusal-kutahya-cavdarhisar-baraj-golu/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('d00c065a-ff44-47b2-992d-7f40e7b04702'::uuid,'ulusal-edirne-cavuskoy-baraj-golu-edirne','Çavuşköy Baraj Gölü Edirne','Edirne',40.6884501,26.2073433,'https://oltaatlasi.com/meralar/ulusal-edirne-cavuskoy-baraj-golu-edirne/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('722a5087-4268-4cd9-9215-3f03b231f565'::uuid,'ankara-500km-kirklareli-cavuskoy-goleti','Çavuşköy Göleti','Kırklareli',41.5326498,27.1977239,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-cavuskoy-goleti/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('22928a72-efe1-4128-a912-fca6d7873989'::uuid,'ankara-500km-giresun-cavuslu-deresi','Çavuşlu Deresi','Giresun',41.0045879,39.0960145,'https://oltaatlasi.com/meralar/ankara-500km-giresun-cavuslu-deresi/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('c08abff0-5326-4c0e-a32e-5ff34920d0f0'::uuid,'ankara-500km-tekirdag-cay-dere','Çay Dere','Tekirdağ',40.743904,27.0932683,'https://oltaatlasi.com/meralar/ankara-500km-tekirdag-cay-dere/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('c6d388ec-4f44-47ea-9196-e5eea2a46593'::uuid,'ulusal-antalya-caybogazi-baraj-golu','Çayboğazı Baraj Gölü','Antalya',36.5227331,29.6791292,'https://oltaatlasi.com/meralar/ulusal-antalya-caybogazi-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('616d8ff1-edb0-43d3-aaab-e1d25a00302b'::uuid,'ulusal-balikesir-caygoren-baraj-golu','Çaygören Baraj Gölü','Balıkesir',39.2511007,28.2352132,'https://oltaatlasi.com/meralar/ulusal-balikesir-caygoren-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz)
)
UPDATE public.fishing_areas AS a
SET latitude = i.latitude,
    longitude = i.longitude,
    coordinates_imported = true,
    coordinate_status = 'province_checked_source_candidate',
    coordinate_note = 'Olta Atlası page-level spatialCoverage candidate; exact mera name and province matched; general location only; not independently cross-checked against OSM/official source; not fishing access or permission.',
    location_confidence_grade = 'D',
    source_checked_at = i.source_checked_at,
    updated_at = now()
FROM input AS i
WHERE a.id = i.id
  AND a.source_slug = i.source_slug
  AND a.name = i.name
  AND a.province_name IS NOT DISTINCT FROM i.province_name
  AND (a.latitude IS NULL OR a.longitude IS NULL);
