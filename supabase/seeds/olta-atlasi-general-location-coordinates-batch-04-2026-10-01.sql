-- Olta Atlası mera general-coordinate batch 04 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('8577b2a5-0178-41f8-9d1c-c93de41a3990'::uuid,'akkoy-baraji-genel-amator-kiyi','Akköy Barajı Genel Amatör Kıyı Rotası','Kayseri',38.3252,35.0192,'https://oltaatlasi.com/meralar/akkoy-baraji-genel-amator-kiyi/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('d6c0b652-9e8e-4441-89e9-a67f77a199c2'::uuid,'ulusal-konya-akoren-baraj-golu','Akören Baraj Gölü','Konya',37.5050092,32.3106184,'https://oltaatlasi.com/meralar/ulusal-konya-akoren-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('0b38038a-e303-414f-a25e-bdb3d1f87578'::uuid,'ankara-500km-mersin-akpinar-goleti','Akpınar Göleti','Mersin',36.8523704,34.0499466,'https://oltaatlasi.com/meralar/ankara-500km-mersin-akpinar-goleti/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('8ab8f5fb-8f06-4eda-ba42-989f06ee39fd'::uuid,'ankara-500km-kirsehir-aksakli-goleti','Aksaklı Göleti','Kırşehir',38.9991223,34.3892358,'https://oltaatlasi.com/meralar/ankara-500km-kirsehir-aksakli-goleti/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('394cb70f-d142-4e62-9066-0b584812bafb'::uuid,'ankara-500km-burdur-aksu-cayi','Aksu Çayı','Burdur',37.3491253,30.8562877,'https://oltaatlasi.com/meralar/ankara-500km-burdur-aksu-cayi/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('dacc5a9b-f8ed-4ca1-ae38-788a3010d210'::uuid,'ankara-500km-kahramanmaras-aksu-cayi','Aksu Çayı','Kahramanmaraş',37.5602379,37.1271139,'https://oltaatlasi.com/meralar/ankara-500km-kahramanmaras-aksu-cayi/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('6d27ddd9-1b5a-478e-8a6e-1f6a6b228313'::uuid,'ankara-500km-duzce-aksu-deresi','Aksu Deresi','Düzce',40.741306,30.9440277,'https://oltaatlasi.com/meralar/ankara-500km-duzce-aksu-deresi/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('9b3ffa22-4ed0-4a6d-80c7-4257bbb2a2fc'::uuid,'ulusal-giresun-aksu-deresi-giresun','Aksu Deresi Giresun','Giresun',40.8856815,38.4159909,'https://oltaatlasi.com/meralar/ulusal-giresun-aksu-deresi-giresun/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('88e29d94-b592-43ff-b58d-a0d23b19fdcc'::uuid,'ulusal-ardahan-aktas-golu','Aktaş Gölü','Ardahan',41.1177,42.8056,'https://oltaatlasi.com/meralar/ulusal-ardahan-aktas-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('de6aae21-02be-4b72-9de4-0a8492368e27'::uuid,'ulusal-ankara-akyar-baraj-golu','Akyar Baraj Gölü','Ankara',40.6032566,32.5847234,'https://oltaatlasi.com/meralar/ulusal-ankara-akyar-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('432534ef-89bd-406c-8439-588de299ad9e'::uuid,'ankara-500km-afyonkarahisar-akyuva-goleti','Akyuva Göleti','Afyonkarahisar',38.5275726,30.4838888,'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-akyuva-goleti/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('f757b3b9-e4f3-4cb3-aa6d-f98d7d579985'::uuid,'ankara-500km-corum-alacahoyuk-goleti','Alacahöyük Göleti','Çorum',40.2479895,34.6816105,'https://oltaatlasi.com/meralar/ankara-500km-corum-alacahoyuk-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('135000e7-7375-4188-af17-039183bde9d9'::uuid,'ulusal-izmir-alacati-baraj-golu','Alaçatı Baraj Gölü','İzmir',38.2824945,26.4060716,'https://oltaatlasi.com/meralar/ulusal-izmir-alacati-baraj-golu/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('c401ae0a-99e4-4706-a0c6-03a97018ba82'::uuid,'ankara-500km-izmir-alacati-kutlu-aktas-baraji','Alaçatı Kutlu Aktaş Barajı','İzmir',38.2921575,26.4150792,'https://oltaatlasi.com/meralar/ankara-500km-izmir-alacati-kutlu-aktas-baraji/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('2b2cfafa-9a6c-4b6f-9db7-297907b51699'::uuid,'bolu-aladag-goleti','Aladağ Göleti','Bolu',40.6111,31.6828,'https://oltaatlasi.com/meralar/bolu-aladag-goleti/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('5012dc5d-497c-4eb1-b2ff-8ad10a67fc3d'::uuid,'ankara-500km-giresun-aladerecam-baraj-golu','Aladereçam Baraj Gölü','Giresun',40.6256415,38.7978724,'https://oltaatlasi.com/meralar/ankara-500km-giresun-aladerecam-baraj-golu/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('174e3878-f509-4f50-b060-c6b0b71e824a'::uuid,'ankara-500km-nigde-alagolbasi-golu','Alagölbaşı Gölü','Niğde',37.9578082,35.212804,'https://oltaatlasi.com/meralar/ankara-500km-nigde-alagolbasi-golu/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('dfd7175b-975d-4bf4-809c-f48fa3a6022b'::uuid,'ankara-500km-usak-alahabali-goleti','Alahabalı Göleti','Uşak',38.4783894,28.8601616,'https://oltaatlasi.com/meralar/ankara-500km-usak-alahabali-goleti/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('8673b6b9-558a-441a-86c1-7fc78e4cadbc'::uuid,'ulusal-antalya-alakir-baraj-golu','Alakır Baraj Gölü','Antalya',36.4362543,30.2491243,'https://oltaatlasi.com/meralar/ulusal-antalya-alakir-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('2f915c6a-c27e-45cc-bb70-5b80f8cc200c'::uuid,'ankara-500km-mersin-alakopru-baraj-golu','Alaköprü Baraj Gölü','Mersin',36.1993493,32.8592652,'https://oltaatlasi.com/meralar/ankara-500km-mersin-alakopru-baraj-golu/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('3f05cd4f-62a7-4280-b344-09fe27628625'::uuid,'ankara-500km-bolu-alanhimmetler-goleti','Alanhimmetler Göleti','Bolu',40.3243483,31.8182569,'https://oltaatlasi.com/meralar/ankara-500km-bolu-alanhimmetler-goleti/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('8f23a7c4-06b5-49bb-9553-1c8362cc897d'::uuid,'ankara-500km-cankiri-alanpinar-goleti','Alanpınar Göleti','Çankırı',40.7455142,33.5911962,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-alanpinar-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('c23321bc-999d-45c7-b9be-5d141645287f'::uuid,'ankara-500km-antalya-alara-cayi','Alara Çayı','Antalya',36.723327,31.9741379,'https://oltaatlasi.com/meralar/ankara-500km-antalya-alara-cayi/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('081e55a7-6200-44aa-b1ca-f35e9f321642'::uuid,'ankara-500km-corum-alembeyli-goleti','Alembeyli Göleti','Çorum',40.0297572,34.2250012,'https://oltaatlasi.com/meralar/ankara-500km-corum-alembeyli-goleti/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('ff42c78f-8075-47e5-8492-e65e1b660fff'::uuid,'ankara-500km-canakkale-alemsah-goleti','Alemşah Göleti','Çanakkale',39.6884417,26.2130368,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-alemsah-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('0cdb91bf-8d83-46c0-951b-9006c424d609'::uuid,'ulusal-istanbul-alibey-baraj-golu','Alibey Baraj Gölü','İstanbul',41.1303321,28.9010269,'https://oltaatlasi.com/meralar/ulusal-istanbul-alibey-baraj-golu/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('9dc512d0-f142-4bf8-9e38-965206321ff5'::uuid,'ankara-500km-nigde-alisar-goleti','Alişar Göleti','Niğde',37.5680471,34.6897608,'https://oltaatlasi.com/meralar/ankara-500km-nigde-alisar-goleti/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('0ec67a24-4d50-40fa-95a7-2c396684801f'::uuid,'ankara-500km-gaziantep-alleben-deresi','Alleben Deresi','Gaziantep',37.0624622,37.3591509,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-alleben-deresi/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('13fbba1c-37a2-498f-b93c-3a74f573731a'::uuid,'ankara-500km-gaziantep-alleben-goleti','Alleben Göleti','Gaziantep',37.0744575,37.2680079,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-alleben-goleti/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('80e482af-c553-4b9f-bf39-1e143adf5da7'::uuid,'ankara-500km-cankiri-alpsari-goleti','Alpsarı Göleti','Çankırı',40.6765636,33.5068562,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-alpsari-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('4d5ed682-7068-4f07-8ce3-c51d2f242be7'::uuid,'ulusal-konya-altinapa-baraj-golu','Altınapa Baraj Gölü','Konya',37.8899809,32.2958589,'https://oltaatlasi.com/meralar/ulusal-konya-altinapa-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('b91156d2-b392-400e-8e2b-67aad9528774'::uuid,'ankara-500km-aksaray-altinkaya-beldesi-asma-baraj-goleti','Altınkaya Beldesi Asma baraj göleti','Aksaray',38.6634947,33.7752359,'https://oltaatlasi.com/meralar/ankara-500km-aksaray-altinkaya-beldesi-asma-baraj-goleti/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('7dab2cf9-4295-4d4d-96f5-331209bece38'::uuid,'altinova-kamusal-sahili','Altınova Kamusal Sahili','Yalova',40.6968,29.5095,'https://oltaatlasi.com/meralar/altinova-kamusal-sahili/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('648a0591-edd6-4e30-8ad0-bb7af5485e49'::uuid,'ankara-500km-yozgat-altinsu-goleti','Altınsu Göleti','Yozgat',39.6445894,35.4773098,'https://oltaatlasi.com/meralar/ankara-500km-yozgat-altinsu-goleti/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('72a43ce7-9dbe-44e2-81ff-ccbb840c07d6'::uuid,'ulusal-edirne-altinyazi-baraj-golu','Altınyazı Baraj Gölü','Edirne',41.0529044,26.5920921,'https://oltaatlasi.com/meralar/ulusal-edirne-altinyazi-baraj-golu/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('7b9828fc-7552-4273-bd13-9ed8c678eaaf'::uuid,'ankara-500km-bartin-amastris-deresi','Amastris Deresi','Bartın',41.7473576,32.3836673,'https://oltaatlasi.com/meralar/ankara-500km-bartin-amastris-deresi/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('4ea96746-f263-45af-bb5b-b66c6965432a'::uuid,'ankara-500km-ankara-anadolu-goleti','Anadolu Göleti','Ankara',39.7938553,32.3991968,'https://oltaatlasi.com/meralar/ankara-500km-ankara-anadolu-goleti/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('f5b9f37d-ced7-4cad-a6bd-f5c3139ed87d'::uuid,'anadolu-hisari-sahili','Anadolu Hisarı Sahili','İstanbul',41.0824,29.0664,'https://oltaatlasi.com/meralar/anadolu-hisari-sahili/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('7549608f-b7a4-4e7b-8124-4d587084f491'::uuid,'anadolu-kavagi','Anadolu Kavağı Kıyıları','İstanbul',41.1744,29.088,'https://oltaatlasi.com/meralar/anadolu-kavagi/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('40c0f6e6-3cf5-4682-a4ac-a4a15a1f2891'::uuid,'ankara-500km-sakarya-anagol','Anagöl','Sakarya',41.0655937,30.8168346,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-anagol/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('c5535136-f447-4822-bcd9-3b65a7042b25'::uuid,'ulusal-konya-apa-baraj-golu','Apa Baraj Gölü','Konya',37.3677301,32.5098677,'https://oltaatlasi.com/meralar/ulusal-konya-apa-baraj-golu/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('e9ec5c2c-09f1-4702-bec1-9eebea5f0b9d'::uuid,'ankara-500km-bursa-arapciftligi-golu','Arapçiftliği Gölü','Bursa',40.3823063,28.5185029,'https://oltaatlasi.com/meralar/ankara-500km-bursa-arapciftligi-golu/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('c2b76acf-267c-41ea-9fcc-21c5640ceeae'::uuid,'ulusal-igdir-aras-nehri-aralik-hatti','Aras Nehri Aralık Hattı','Iğdır',39.9719843,44.4615347,'https://oltaatlasi.com/meralar/ulusal-igdir-aras-nehri-aralik-hatti/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('502932c1-f4cf-4212-9581-ce3347af9446'::uuid,'ankara-500km-erzincan-ardicli-gol','Ardıçlı Göl','Erzincan',39.6303586,39.499449,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-ardicli-gol/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('b728ed4c-a99f-4446-a003-f842479a693c'::uuid,'ankara-500km-adiyaman-ardil-baraj-golu','Ardıl Baraj Gölü','Adıyaman',37.5004856,37.6100486,'https://oltaatlasi.com/meralar/ankara-500km-adiyaman-ardil-baraj-golu/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('b91b6084-ceca-4493-b95f-6d325c100c17'::uuid,'ankara-500km-gaziantep-ardil-deresi','Ardıl Deresi','Gaziantep',37.4567574,37.6141084,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-ardil-deresi/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('158a6889-6fe8-4f31-a0d6-98143a167314'::uuid,'ankara-500km-erzincan-ardos-golu','Ardos Gölü','Erzincan',39.6644616,39.300731,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-ardos-golu/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('38bfc88a-5861-49f8-874c-f7d790f231a7'::uuid,'ulusal-bitlis-arin-golu','Arin Gölü','Bitlis',38.8115566,42.9863065,'https://oltaatlasi.com/meralar/ulusal-bitlis-arin-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('768be41f-e19a-4016-b0e8-06f6f86fc7a1'::uuid,'ankara-500km-izmir-arikbasi-goleti','Arıkbaşı Göleti','İzmir',38.2105172,27.4746668,'https://oltaatlasi.com/meralar/ankara-500km-izmir-arikbasi-goleti/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('6bb11d91-c608-41b6-af5e-87605a22cbe7'::uuid,'ankara-500km-kocaeli-ariklar-baraj-golu','Arıklar Baraj Gölü','Kocaeli',40.9527987,30.2076169,'https://oltaatlasi.com/meralar/ankara-500km-kocaeli-ariklar-baraj-golu/','2026-09-30 14:58:11.25239+00'::timestamptz)
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
