-- Olta Atlası mera general-coordinate batch 07 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('4e79fc3b-67c1-4d03-9be7-2bce87c69712'::uuid,'ankara-500km-kutahya-belkavak-goleti','Belkavak Göleti','Kütahya',39.3289076,30.2302793,'https://oltaatlasi.com/meralar/ankara-500km-kutahya-belkavak-goleti/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('7047f8dd-f6ea-4ede-b17a-678934bee5a8'::uuid,'ulusal-burdur-belkaya-baraj-golu','Belkaya Baraj Gölü','Burdur',37.2883505,29.6053438,'https://oltaatlasi.com/meralar/ulusal-burdur-belkaya-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('8db056d7-33c9-4dd3-b60c-fc2530dc1ebf'::uuid,'ankara-500km-tokat-belkaya-goleti','Belkaya Göleti','Tokat',40.210397,35.8353169,'https://oltaatlasi.com/meralar/ankara-500km-tokat-belkaya-goleti/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('81e2fe3e-e516-4514-9899-3827e8ba48e7'::uuid,'ulusal-mersin-berdan-baraj-golu','Berdan Baraj Gölü','Mersin',36.9805756,34.88149,'https://oltaatlasi.com/meralar/ulusal-mersin-berdan-baraj-golu/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('1cfb1e64-1a7b-4c4c-b4b5-9712bdf0623c'::uuid,'ankara-500km-kahramanmaras-berke-baraj-golu','Berke Baraj Gölü','Kahramanmaraş',37.4358352,36.52716,'https://oltaatlasi.com/meralar/ankara-500km-kahramanmaras-berke-baraj-golu/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('300982ac-30d7-4fe1-a0a8-b1ed8a632e4e'::uuid,'ankara-500km-sakarya-besevler-goleti','Beşevler Göleti','Sakarya',40.8052624,30.2266636,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-besevler-goleti/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('dc144403-d97d-4797-907d-b458d9f07fa5'::uuid,'ankara-500km-erzincan-besgoze-goleti','Beşgöze Göleti','Erzincan',39.6666673,40.4330109,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-besgoze-goleti/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('ff703e5b-ba0c-46f9-8791-26b3177cbab3'::uuid,'ulusal-kutahya-beskaris-baraj-golu','Beşkarış Baraj Gölü','Kütahya',38.9300527,30.1440645,'https://oltaatlasi.com/meralar/ulusal-kutahya-beskaris-baraj-golu/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('5420e012-774b-46e9-8f0d-b76c90fdb173'::uuid,'ankara-500km-hatay-beyazcay','Beyazçay','Hatay',36.1115962,36.2681307,'https://oltaatlasi.com/meralar/ankara-500km-hatay-beyazcay/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('d2eefcb1-d53b-4cc0-9a8a-8a7dd9760eff'::uuid,'ankara-500km-konya-beykavagi-goleti','Beykavağı Göleti','Konya',38.139408,32.261493,'https://oltaatlasi.com/meralar/ankara-500km-konya-beykavagi-goleti/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('9c6f33f5-3bab-4294-bcf5-086637c29585'::uuid,'beykoz-merkez-sahili','Beykoz Merkez Sahili','İstanbul',41.1342,29.0904,'https://oltaatlasi.com/meralar/beykoz-merkez-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('8bd191a4-dfca-4811-b7dc-b9b5baafb164'::uuid,'ankara-500km-kastamonu-beyler-baraj-golu','Beyler Baraj Gölü','Kastamonu',41.684874,33.7972908,'https://oltaatlasi.com/meralar/ankara-500km-kastamonu-beyler-baraj-golu/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('3bd1d3d0-cca0-481c-b475-d18b4cf681a5'::uuid,'ankara-500km-denizli-beylerbey-baraj-golu','Beylerbey Baraj Gölü','Denizli',37.668097,29.6146599,'https://oltaatlasi.com/meralar/ankara-500km-denizli-beylerbey-baraj-golu/','2026-09-30 14:55:46.378408+00'::timestamptz),
    ('c1a344d2-703c-4093-b67f-0f9377465034'::uuid,'beylerbeyi-sahili','Beylerbeyi Sahili','İstanbul',41.0425,29.0405,'https://oltaatlasi.com/meralar/beylerbeyi-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('c7ce5a9c-2e05-4587-8a5a-95022e23fb40'::uuid,'ankara-500km-malatya-beylerderesi-baraj-goleti','Beylerderesi Baraj Göleti','Malatya',38.3268528,38.2111456,'https://oltaatlasi.com/meralar/ankara-500km-malatya-beylerderesi-baraj-goleti/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('7953b771-7509-4152-b00c-6030d3d876e0'::uuid,'ankara-500km-konya-beysehir-cayi','Beyşehir Çayı','Konya',37.5094805,31.955979,'https://oltaatlasi.com/meralar/ankara-500km-konya-beysehir-cayi/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('8df70ff1-b4b3-46e6-bf69-7c5e3954fce3'::uuid,'ulusal-kastamonu-bezirgan-baraj-golu','Bezirgan Baraj Gölü','Kastamonu',41.3840296,33.4082234,'https://oltaatlasi.com/meralar/ulusal-kastamonu-bezirgan-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('097a31c5-4985-409d-8333-f4aad560208b'::uuid,'ankara-500km-canakkale-biga-cayi','Biga Çayı','Çanakkale',40.1270777,27.1249581,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-biga-cayi/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('d69553be-f8a1-43c6-a662-f9a0b29f063c'::uuid,'ankara-500km-istanbul-binkilic-deresi','Binkılıç Deresi','İstanbul',41.3928157,28.2918151,'https://oltaatlasi.com/meralar/ankara-500km-istanbul-binkilic-deresi/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('44e8c637-03c7-4b5f-8d4f-45605d8fb7bc'::uuid,'ulusal-gaziantep-birecik-baraj-golu-gaziantep-kiyisi','Birecik Baraj Gölü Gaziantep Kıyısı','Gaziantep',37.2508584,37.8479968,'https://oltaatlasi.com/meralar/ulusal-gaziantep-birecik-baraj-golu-gaziantep-kiyisi/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('66179932-f730-4819-a2bb-b84ea16335a5'::uuid,'ankara-500km-kirklareli-birinci-goleti','Birinci Göleti','Kırklareli',41.5152661,27.5960625,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-birinci-goleti/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('8d5e9bc0-6d48-4bd0-ad13-1886e0d577fb'::uuid,'ankara-500km-nigde-bitli-gol','Bitli Göl','Niğde',37.8868229,35.2068866,'https://oltaatlasi.com/meralar/ankara-500km-nigde-bitli-gol/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('18a061a2-7634-4dfc-a566-405f1d295acb'::uuid,'ankara-500km-antalya-bickici-cayi','Bıçkıcı Çayı','Antalya',36.3575167,32.377015,'https://oltaatlasi.com/meralar/ankara-500km-antalya-bickici-cayi/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('3f0ea540-4c27-4e40-a308-1de8f106d39e'::uuid,'ankara-500km-antalya-boga-cayi','Boğa Çayı','Antalya',36.8946974,30.6240238,'https://oltaatlasi.com/meralar/ankara-500km-antalya-boga-cayi/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('7ba7fdb7-7378-4f21-a4d4-c7822fb3a48d'::uuid,'ulusal-bursa-bogazkoy-baraj-golu','Boğazköy Baraj Gölü','Bursa',40.1549646,29.5100108,'https://oltaatlasi.com/meralar/ulusal-bursa-bogazkoy-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('2f4e61e1-7ef8-4fb7-96ab-a54f139e229e'::uuid,'ulusal-ordu-bolaman-irmagi','Bolaman Irmağı','Ordu',40.6866351,37.4092483,'https://oltaatlasi.com/meralar/ulusal-ordu-bolaman-irmagi/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('ea46cbca-7dc3-4f29-81a3-57580c75466f'::uuid,'ankara-500km-zonguldak-bolu-cayi','Bolu Çayı','Zonguldak',41.199235,31.9401865,'https://oltaatlasi.com/meralar/ankara-500km-zonguldak-bolu-cayi/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('687e114b-3f88-4cb0-8ec5-b0bb303f60a3'::uuid,'ankara-500km-amasya-borabay-golu','Borabay Gölü','Amasya',40.8037815,36.1542137,'https://oltaatlasi.com/meralar/ankara-500km-amasya-borabay-golu/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('da0c0cbd-2449-4927-9285-85911e8935d3'::uuid,'ankara-500km-mugla-boranda-goleti','Boranda Göleti','Muğla',36.6469323,29.7178958,'https://oltaatlasi.com/meralar/ankara-500km-mugla-boranda-goleti/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('8d34505f-ca44-4597-9a19-940f4d09a4f9'::uuid,'ulusal-bilecik-borcak-baraj-golu','Borçak Baraj Gölü','Bilecik',40.0395627,30.2077358,'https://oltaatlasi.com/meralar/ulusal-bilecik-borcak-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('82c27b9f-5371-4900-83fa-a418951f05ac'::uuid,'ulusal-artvin-borcka-baraj-golu','Borçka Baraj Gölü','Artvin',41.2614112,41.7775754,'https://oltaatlasi.com/meralar/ulusal-artvin-borcka-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('b62952fb-5632-465f-b4cd-4dce7168750e'::uuid,'bostanci-sahili','Bostancı Sahili','İstanbul',40.953,29.094,'https://oltaatlasi.com/meralar/bostanci-sahili/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('e512c04b-b858-4bf3-afe4-ddb99e7a43eb'::uuid,'ankara-500km-sinop-boyabat-baraj-golu','Boyabat Baraj Gölü','Sinop',41.2263904,34.7971303,'https://oltaatlasi.com/meralar/ankara-500km-sinop-boyabat-baraj-golu/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('38ce9139-ca5d-45d4-93c5-3eb39427fe00'::uuid,'ankara-500km-sinop-boyali-goleti','Boyalı Göleti','Sinop',41.3776889,34.6577648,'https://oltaatlasi.com/meralar/ankara-500km-sinop-boyali-goleti/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('5d04cc99-6b59-4368-9096-d2a0765ffb5e'::uuid,'ankara-500km-afyonkarahisar-boyali-goleti','Boyalı Göleti','Afyonkarahisar',38.7624746,30.422261,'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-boyali-goleti/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('942adaf9-bd93-4aea-a802-8085e3be2147'::uuid,'ankara-500km-burdur-boz-cayi','Boz Çayı','Burdur',37.5019358,30.0260385,'https://oltaatlasi.com/meralar/ankara-500km-burdur-boz-cayi/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('64c55ebe-8de2-4de7-accd-cc3ec820ddd9'::uuid,'bilecik-bozcaarmut-baraj-goleti','Bozcaarmut Baraj Göleti','Bilecik',39.96202,29.78818,'https://oltaatlasi.com/meralar/bilecik-bozcaarmut-baraj-goleti/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('b8b0fc1b-50bb-4918-8fea-1c06690f46d3'::uuid,'ulusal-aksaray-bozkir-baraj-golu','Bozkır Baraj Gölü','Aksaray',38.7625678,34.0800624,'https://oltaatlasi.com/meralar/ulusal-aksaray-bozkir-baraj-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('d969a6fd-b2cb-4a35-8f13-70f4fd053d63'::uuid,'ankara-500km-cankiri-bozoglu-goleti','Bozoğlu Göleti','Çankırı',40.7762957,32.9178844,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-bozoglu-goleti/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('aa206ec8-68ac-407a-a56c-9b17f134dfd9'::uuid,'ulusal-malatya-boztepe-baraj-golu-malatya','Boztepe Baraj Gölü Malatya','Malatya',38.7020149,38.1412323,'https://oltaatlasi.com/meralar/ulusal-malatya-boztepe-baraj-golu-malatya/','2026-09-30 15:09:23.096205+00'::timestamptz),
    ('e3e99a4e-4a85-4a33-8c6b-93b1d2e6cf20'::uuid,'ankara-500km-ordu-budak-deresi','Budak Deresi','Ordu',40.9162237,37.5518121,'https://oltaatlasi.com/meralar/ankara-500km-ordu-budak-deresi/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('e3f67bda-6b43-4a4c-ba11-41d28b8ff294'::uuid,'ankara-500km-osmaniye-bugdaycik','Buğdaycık','Osmaniye',37.1579311,36.5238834,'https://oltaatlasi.com/meralar/ankara-500km-osmaniye-bugdaycik/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('0108b343-7218-4ee2-8a47-ebec74908af5'::uuid,'ankara-500km-burdur-bugduz-baraj-golu','Büğdüz Baraj Gölü','Burdur',37.5896107,30.2718294,'https://oltaatlasi.com/meralar/ankara-500km-burdur-bugduz-baraj-golu/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('a7b6e090-eede-47af-bda9-e601020ae36b'::uuid,'ankara-500km-kastamonu-buk-deresi','Bük Deresi','Kastamonu',41.6712376,33.9573427,'https://oltaatlasi.com/meralar/ankara-500km-kastamonu-buk-deresi/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('8203af86-e15a-448b-96fb-c4d3702832e1'::uuid,'ankara-500km-karabuk-bulak-deresi','Bulak Deresi','Karabük',41.2154815,32.6753506,'https://oltaatlasi.com/meralar/ankara-500km-karabuk-bulak-deresi/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('5fd7b5f4-08c0-41b8-9831-0c2d2fe54c47'::uuid,'ankara-500km-kirklareli-bulanik-dere','Bulanık Dere','Kırklareli',41.8368333,27.846006,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-bulanik-dere/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('2dffe5dc-1565-49ab-90fa-b1a16edba182'::uuid,'ankara-500km-yalova-bulbul-deresi','Bülbül Deresi','Yalova',40.5147968,28.8264825,'https://oltaatlasi.com/meralar/ankara-500km-yalova-bulbul-deresi/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('0de6c185-78d0-4835-95da-e512edfaff00'::uuid,'ulusal-denizli-buldan-baraj-golu','Buldan Baraj Gölü','Denizli',38.1440859,28.8473556,'https://oltaatlasi.com/meralar/ulusal-denizli-buldan-baraj-golu/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('80b8b356-a6f3-4380-8ef9-abf31d902916'::uuid,'ankara-500km-gaziantep-burc-goleti','Burç Göleti','Gaziantep',37.0631018,37.1687233,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-burc-goleti/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('c62ff49a-98a3-4edf-9f44-853ed3adeff3'::uuid,'ankara-500km-hatay-buyuk-karacay','Büyük Karaçay','Hatay',36.1196002,36.058803,'https://oltaatlasi.com/meralar/ankara-500km-hatay-buyuk-karacay/','2026-09-30 14:56:46.592068+00'::timestamptz)
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
