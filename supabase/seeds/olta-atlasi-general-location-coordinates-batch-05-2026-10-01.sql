-- Olta Atlası mera general-coordinate batch 05 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('dc520f9a-35ac-4653-b811-60de8cdd3829'::uuid,'ankara-500km-bartin-arit-cayi','Arıt Çayı','Bartın',41.6315543,32.390746,'https://oltaatlasi.com/meralar/ankara-500km-bartin-arit-cayi/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('1184233f-ad44-49a2-903e-00f6eb62e1df'::uuid,'ulusal-kirklareli-armagan-baraj-golu','Armağan Baraj Gölü','Kırklareli',41.904439,27.4258803,'https://oltaatlasi.com/meralar/ulusal-kirklareli-armagan-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('3bf9bf0f-a6fd-42ee-ab33-a127e4aa27ff'::uuid,'armutlu-merkez-sahili','Armutlu Merkez Sahili','Yalova',40.5192,28.8287,'https://oltaatlasi.com/meralar/armutlu-merkez-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('e044875c-03b0-42be-9122-4ffd7f97d794'::uuid,'arnavutkoy-besiktas-sahili','Arnavutköy Sahili','İstanbul',41.067,29.0432,'https://oltaatlasi.com/meralar/arnavutkoy-besiktas-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('a6820dd7-806b-4915-9470-ab3071d8f969'::uuid,'ulusal-kars-arpacay-baraj-golu','Arpaçay Baraj Gölü','Kars',40.595458,43.6876921,'https://oltaatlasi.com/meralar/ulusal-kars-arpacay-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('36693149-7f7d-42a7-b2eb-f7edc8c24896'::uuid,'ankara-500km-samsun-asaginarli-baraj-golu','Aşağınarlı Baraj Gölü','Samsun',41.2023059,35.2768035,'https://oltaatlasi.com/meralar/ankara-500km-samsun-asaginarli-baraj-golu/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('0dde74c3-92b4-4272-8924-ff87aa254551'::uuid,'ankara-500km-canakkale-asagiokcular-goleti','Aşağıokçular Göleti','Çanakkale',40.0426067,26.4547217,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-asagiokcular-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('6ac52055-a230-407f-8d33-63b29cb6e0d0'::uuid,'ulusal-ankara-asartepe-baraj-golu','Asartepe Baraj Gölü','Ankara',40.145811,32.3957994,'https://oltaatlasi.com/meralar/ulusal-ankara-asartepe-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('cc42c13d-63cb-4879-bcd5-f5abd08dea05'::uuid,'ankara-500km-nigde-asbamaion','Asbamaion','Niğde',37.8011757,34.6316353,'https://oltaatlasi.com/meralar/ankara-500km-nigde-asbamaion/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('5569be7b-c259-4793-96fa-f307eccd67cb'::uuid,'ankara-500km-burdur-askeriye-goleti','Askeriye Göleti','Burdur',37.7528774,30.3509303,'https://oltaatlasi.com/meralar/ankara-500km-burdur-askeriye-goleti/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('990d56a9-9999-4370-a47d-3f542d6836a1'::uuid,'ankara-500km-kilis-aslan-suyu','Aslan Suyu','Kilis',36.8000215,37.0799571,'https://oltaatlasi.com/meralar/ankara-500km-kilis-aslan-suyu/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('3566b9f0-d47e-4e36-b197-9a9b7bdcbdcb'::uuid,'ankara-500km-sakarya-aslanlar-goleti','Aslanlar Göleti','Sakarya',40.9314755,30.3861018,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-aslanlar-goleti/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('32c865e3-06a6-498f-a0a9-568355fef723'::uuid,'ulusal-isparta-atabey-baraj-golu','Atabey Baraj Gölü','Isparta',37.9475987,30.6119982,'https://oltaatlasi.com/meralar/ulusal-isparta-atabey-baraj-golu/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('a9bcc282-6ccb-44bc-9fc8-7602cb6a6d60'::uuid,'kocaeli-korfez-atalar-sahili','Atalar Sahili','Kocaeli',40.77213,29.72883,'https://oltaatlasi.com/meralar/kocaeli-korfez-atalar-sahili/','2026-09-30 15:07:07.329215+00'::timestamptz),
    ('893425de-7d6b-4505-bf7c-ebe2530bdcdc'::uuid,'ataturk-unkapani-koprusu','Atatürk (Unkapanı) Köprüsü','İstanbul',41.022995,28.962433,'https://oltaatlasi.com/meralar/ataturk-unkapani-koprusu/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('4de1d972-d39c-4c4d-b4ee-f11fb138378a'::uuid,'ankara-500km-adiyaman-ataturk-baraj-golu','Atatürk Baraj Gölü','Adıyaman',37.800606,38.7532257,'https://oltaatlasi.com/meralar/ankara-500km-adiyaman-ataturk-baraj-golu/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('4dcfc4c8-443a-4058-a33a-411d5c7ad8ee'::uuid,'ulusal-canakkale-atikhisar-baraj-golu','Atikhisar Baraj Gölü','Çanakkale',40.0983239,26.5250716,'https://oltaatlasi.com/meralar/ulusal-canakkale-atikhisar-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('caeacf0d-2710-4c01-9a00-4ec12c7d6e9d'::uuid,'istanbul-avcilar-avcilar-sahil-parki','Avcılar Sahil Parkı','İstanbul',40.9708,28.7167,'https://oltaatlasi.com/meralar/istanbul-avcilar-avcilar-sahil-parki/','2026-09-30 15:07:07.329215+00'::timestamptz),
    ('6463ee1f-090f-4650-8647-c84e124ad953'::uuid,'ankara-500km-antalya-avlan-golu','Avlan Gölü','Antalya',36.5812634,29.9442939,'https://oltaatlasi.com/meralar/ankara-500km-antalya-avlan-golu/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('08ad0025-b65b-406d-8430-3d04c23c1d26'::uuid,'ankara-500km-giresun-avutmus-cayi','Avutmuş Çayı','Giresun',40.2651989,38.4155846,'https://oltaatlasi.com/meralar/ankara-500km-giresun-avutmus-cayi/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('2571a3b8-f1ea-4a7a-8ab0-e0ae85b083b8'::uuid,'ankara-500km-istanbul-ayamama-deresi','Ayamama Deresi','İstanbul',41.0516073,28.823507,'https://oltaatlasi.com/meralar/ankara-500km-istanbul-ayamama-deresi/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('2124ca7c-9d2e-4d92-a74e-5288825a5b06'::uuid,'ankara-500km-canakkale-ayazma-deresi','Ayazma Deresi','Çanakkale',39.7711793,26.7974747,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-ayazma-deresi/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('00b3e166-362e-471d-9a6c-6ccdd752620e'::uuid,'ankara-500km-zonguldak-aydinlar-cayi','Aydınlar Çayı','Zonguldak',41.2416059,31.6525703,'https://oltaatlasi.com/meralar/ankara-500km-zonguldak-aydinlar-cayi/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('fe3b8569-9455-4ace-ba5b-c3f94bad85a8'::uuid,'ankara-500km-mersin-aydinlar-goleti','Aydınlar Göleti','Mersin',36.7827896,34.1283152,'https://oltaatlasi.com/meralar/ankara-500km-mersin-aydinlar-goleti/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('436a11f1-a61e-4c31-83fc-f684ae153aae'::uuid,'ankara-500km-denizli-aydinlar-akbas-baraj-golu','Aydınlar-Akbaş Baraj Gölü','Denizli',37.7501467,29.3891665,'https://oltaatlasi.com/meralar/ankara-500km-denizli-aydinlar-akbas-baraj-golu/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('ad8d393f-eb7a-4331-8609-143f43f8320b'::uuid,'ankara-500km-denizli-aydogdu-goleti','Aydoğdu Göleti','Denizli',37.5389569,29.1806717,'https://oltaatlasi.com/meralar/ankara-500km-denizli-aydogdu-goleti/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('7097756a-d165-4a0d-91cc-44163b6b7345'::uuid,'ankara-500km-kastamonu-aydos-cayi','Aydos Çayı','Kastamonu',41.9101794,33.1003614,'https://oltaatlasi.com/meralar/ankara-500km-kastamonu-aydos-cayi/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('8ae36653-2921-408f-b1bd-461e606590b2'::uuid,'ankara-500km-istanbul-aydos-goleti','Aydos Göleti','İstanbul',40.9561163,29.2297278,'https://oltaatlasi.com/meralar/ankara-500km-istanbul-aydos-goleti/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('784e7779-df44-45ef-87dd-8830549bf6ea'::uuid,'ankara-500km-erzincan-aygir-agu-golu','Aygır (Agu) Gölü','Erzincan',39.7592104,39.8260996,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-aygir-agu-golu/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('c74a9daf-3621-41ce-a67f-6a76aab6de16'::uuid,'ulusal-bitlis-aygir-golu-bitlis','Aygır Gölü Bitlis','Bitlis',38.8370664,42.8224361,'https://oltaatlasi.com/meralar/ulusal-bitlis-aygir-golu-bitlis/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('af179ffd-0043-4c82-86bb-9a82aadd6a9b'::uuid,'ankara-500km-nevsehir-ayhan-baraj-golu','Ayhan Baraj Gölü','Nevşehir',38.8258264,34.7207854,'https://oltaatlasi.com/meralar/ankara-500km-nevsehir-ayhan-baraj-golu/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('266eec7b-052d-4302-8032-231ea9d5d26a'::uuid,'ankara-500km-canakkale-ayitdere-goleti','Ayıtdere Göleti','Çanakkale',40.3461716,27.064149,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-ayitdere-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('78ed00a5-2396-46c8-b69b-4b3bf1f6c122'::uuid,'ankara-500km-gaziantep-aynifar-deresi','Aynifar Deresi','Gaziantep',36.7922106,37.6115992,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-aynifar-deresi/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('1aaaf1fd-234c-404b-9a9a-61277eb405a4'::uuid,'ulusal-karaman-ayranci-baraj-golu','Ayrancı Baraj Gölü','Karaman',37.3292986,33.7293683,'https://oltaatlasi.com/meralar/ulusal-karaman-ayranci-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('c9c326bc-6de2-46af-8150-030a119664a8'::uuid,'ankara-500km-kahramanmaras-ayvali-baraj-golu','Ayvalı Baraj Gölü','Kahramanmaraş',37.5697843,37.1514251,'https://oltaatlasi.com/meralar/ankara-500km-kahramanmaras-ayvali-baraj-golu/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('08c3eaa5-9e26-4ac4-a9c3-394c2d67a58d'::uuid,'ankara-500km-kutahya-ayvali-goleti','Ayvalı Göleti','Kütahya',39.5608646,29.3797966,'https://oltaatlasi.com/meralar/ankara-500km-kutahya-ayvali-goleti/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('11995bf7-5fc5-4892-b5a3-d776d6d7d944'::uuid,'ankara-500km-kirklareli-ayvali-goleti','Ayvalı Göleti','Kırklareli',41.4487204,27.3135851,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-ayvali-goleti/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('391ecf3f-b4f8-4383-bf01-bd0727f78dc0'::uuid,'ankara-500km-kirsehir-ayvali-golu','Ayvalı Gölü','Kırşehir',39.7304596,34.0558104,'https://oltaatlasi.com/meralar/ankara-500km-kirsehir-ayvali-golu/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('ce6ebe46-ac11-4414-8ce1-50a51680780f'::uuid,'ankara-500km-malatya-ayvalitohma-cayi','Ayvalıtohma Çayı','Malatya',38.624663,37.6392958,'https://oltaatlasi.com/meralar/ankara-500km-malatya-ayvalitohma-cayi/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('01529969-4562-48b4-92dd-52c70d9d3222'::uuid,'ankara-500km-aydin-azap-golu','Azap Gölü','Aydın',37.5904114,27.4481565,'https://oltaatlasi.com/meralar/ankara-500km-aydin-azap-golu/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('544a6221-398b-48e5-a6c3-6fdd56530fa0'::uuid,'ankara-500km-adiyaman-azapli-gol','Azaplı Göl','Adıyaman',37.7514349,37.5566972,'https://oltaatlasi.com/meralar/ankara-500km-adiyaman-azapli-gol/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('dca9c369-3f43-4068-9e92-e5ce5c9493e1'::uuid,'ankara-500km-mugla-azmak-cayi','Azmak Çayı','Muğla',37.0539893,28.3372994,'https://oltaatlasi.com/meralar/ankara-500km-mugla-azmak-cayi/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('45c8a294-223d-44be-a06a-b8d2eb4d3cdc'::uuid,'ulusal-bursa-babasultan-baraj-golu','Babasultan Baraj Gölü','Bursa',40.1349429,29.3798949,'https://oltaatlasi.com/meralar/ulusal-bursa-babasultan-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('3bc757aa-cdaa-43b9-b986-e459e70e2530'::uuid,'ulusal-burdur-bademli-baraj-golu','Bademli Baraj Gölü','Burdur',37.4360513,29.9050634,'https://oltaatlasi.com/meralar/ulusal-burdur-bademli-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('8e2d133d-7250-4b94-a81c-26f4624d7615'::uuid,'ankara-500km-aydin-bafa-golu','Bafa Gölü','Aydın',37.5152559,27.4531003,'https://oltaatlasi.com/meralar/ankara-500km-aydin-bafa-golu/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('05de21fd-791a-435a-86ce-d86dfb9be8f4'::uuid,'ulusal-mugla-bafa-golu-mugla-kiyisi','Bafa Gölü Muğla Kıyısı','Muğla',37.5152564,27.4245431,'https://oltaatlasi.com/meralar/ulusal-mugla-bafa-golu-mugla-kiyisi/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('4adfc9b0-780d-49c3-a74d-6e2971056e6f'::uuid,'ankara-500km-konya-bagbasi-baraj-golu','Bağbaşı Baraj Gölü','Konya',37.1107945,32.4188166,'https://oltaatlasi.com/meralar/ankara-500km-konya-bagbasi-baraj-golu/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('5ff48ac6-56ba-4dc0-b61e-0b2500f19bfb'::uuid,'kocaeli-kandira-bagirganli-sahili','Bağırganlı Sahili','Kocaeli',41.13407,30.01986,'https://oltaatlasi.com/meralar/kocaeli-kandira-bagirganli-sahili/','2026-09-30 15:07:07.329215+00'::timestamptz),
    ('23373c9f-13e8-47a2-8452-697ed2600b22'::uuid,'ankara-500km-erzincan-bagistas-1-baraj-golu','Bağıştaş 1 Baraj Gölü','Erzincan',39.4837814,38.5702573,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-bagistas-1-baraj-golu/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('808ffbd2-9d25-4cca-92a4-10cf56a1e4a3'::uuid,'ankara-500km-isparta-bagkonak-goleti','Bağkonak Göleti','Isparta',38.2218393,31.2844407,'https://oltaatlasi.com/meralar/ankara-500km-isparta-bagkonak-goleti/','2026-09-30 14:56:46.592068+00'::timestamptz)
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
