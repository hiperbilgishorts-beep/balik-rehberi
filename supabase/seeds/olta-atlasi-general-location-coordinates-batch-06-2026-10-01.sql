-- Olta Atlası mera general-coordinate batch 06 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('c6efbe80-2141-41af-a96e-03fa51ec6b97'::uuid,'ankara-500km-amasya-baglica-goleti','Bağlıca Göleti','Amasya',40.6145696,35.6894094,'https://oltaatlasi.com/meralar/ankara-500km-amasya-baglica-goleti/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('8bf6514b-87d1-48c3-a131-522ca2dc61a3'::uuid,'ankara-500km-manisa-bagyolu-baraji-goleti','Bağyolu Barajı Göleti','Manisa',38.7242293,27.3324834,'https://oltaatlasi.com/meralar/ankara-500km-manisa-bagyolu-baraji-goleti/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('c1315c01-a7c1-4f22-993b-56451e35e17d'::uuid,'ankara-500km-usak-bahadir-goleti','Bahadır Göleti','Uşak',38.853215,29.7879159,'https://oltaatlasi.com/meralar/ankara-500km-usak-bahadir-goleti/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('40b505c1-8819-4069-9200-a202e7db5143'::uuid,'ankara-500km-kayseri-bahcecik-baraj-golu','Bahçecik Baraj Gölü','Kayseri',38.6992053,36.3370222,'https://oltaatlasi.com/meralar/ankara-500km-kayseri-bahcecik-baraj-golu/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('ae896ad8-6330-4eb4-b04c-9ecc9ec02c87'::uuid,'eskisehir-sivrihisar-bahcecik-goleti','Bahçecik Göleti','Eskişehir',39.4197,31.34179,'https://oltaatlasi.com/meralar/eskisehir-sivrihisar-bahcecik-goleti/','2026-09-30 15:06:48.197096+00'::timestamptz),
    ('dbc04d1f-979c-4ea3-8b10-8a1aaa62893d'::uuid,'ulusal-kayseri-bahcelik-baraj-golu','Bahçelik Baraj Gölü','Kayseri',38.6758468,36.2917239,'https://oltaatlasi.com/meralar/ulusal-kayseri-bahcelik-baraj-golu/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('39a40ca7-af1c-43e0-bc5a-5beb5fb801c1'::uuid,'bahcelik-baraji-resmi-amator-balikcilik-alani','Bahçelik Barajı Resmî Amatör Balıkçılık Alanı','Kayseri',38.6863,36.2973,'https://oltaatlasi.com/meralar/bahcelik-baraji-resmi-amator-balikcilik-alani/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('8b4b9100-f196-4ad1-9e9a-5fd20757560f'::uuid,'ankara-500km-istanbul-bahcesehir-goleti','Bahçeşehir Göleti','İstanbul',41.0691446,28.6920299,'https://oltaatlasi.com/meralar/ankara-500km-istanbul-bahcesehir-goleti/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('adbfecd4-9332-484e-880d-2f91406ff05c'::uuid,'ankara-500km-eskisehir-bahtiyar-goleti','Bahtiyar Göleti','Eskişehir',39.8945674,31.7129209,'https://oltaatlasi.com/meralar/ankara-500km-eskisehir-bahtiyar-goleti/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('75db4f82-b6c1-466e-a4d1-45f9bbe0ee39'::uuid,'ulusal-canakkale-bakacak-baraj-golu','Bakacak Baraj Gölü','Çanakkale',40.1676454,27.0060984,'https://oltaatlasi.com/meralar/ulusal-canakkale-bakacak-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('fa79b42f-f266-4040-b758-613a50cb6bd4'::uuid,'ankara-500km-izmir-bakircay','Bakırçay','İzmir',39.0607193,27.3331106,'https://oltaatlasi.com/meralar/ankara-500km-izmir-bakircay/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('4d5ec03e-cee3-43f5-a5df-89f6bbc8d518'::uuid,'bakirkoy-sahili','Bakırköy Sahili','İstanbul',40.9704,28.8742,'https://oltaatlasi.com/meralar/bakirkoy-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('cd7d33e9-f542-4eed-bf27-1a9909ac3ba5'::uuid,'ankara-500km-cankiri-bakkal-golu','Bakkal Gölü','Çankırı',40.5909175,33.6802074,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-bakkal-golu/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('67841ae8-2651-4b85-b481-27b218305e85'::uuid,'ankara-500km-bilecik-bakras-cayi','Bakraş Çayı','Bilecik',40.0409741,29.8461558,'https://oltaatlasi.com/meralar/ankara-500km-bilecik-bakras-cayi/','2026-09-30 14:55:04.660289+00'::timestamptz),
    ('d2556fe2-9b30-443a-8d5c-65f25132f484'::uuid,'ankara-500km-yalova-balaban-deresi','BALABAN DERESİ','Yalova',40.6502559,29.2854624,'https://oltaatlasi.com/meralar/ankara-500km-yalova-balaban-deresi/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('d0173656-de85-43fc-8b0f-de8048233c07'::uuid,'ankara-500km-balikesir-balat-cayi','Balat Çayı','Balıkesir',39.570706,28.670401,'https://oltaatlasi.com/meralar/ankara-500km-balikesir-balat-cayi/','2026-09-30 14:54:43.93472+00'::timestamptz),
    ('197c430b-2189-4711-a7c4-f2bad639c673'::uuid,'balat-halic-kamusal-sahil-hatti','Balat Haliç Kamusal Sahil Hattı','İstanbul',41.0343,28.9463,'https://oltaatlasi.com/meralar/balat-halic-kamusal-sahil-hatti/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('b9a8a37f-6bbb-4f11-a46b-da1e9544082c'::uuid,'istanbul-fatih-balat-sair-nedim-parki-sahili','Balat Şair Nedim Parkı Sahili','İstanbul',41.0329,28.9466,'https://oltaatlasi.com/meralar/istanbul-fatih-balat-sair-nedim-parki-sahili/','2026-09-30 15:07:07.329215+00'::timestamptz),
    ('449327e4-f611-4c10-bb58-a7506e4c011c'::uuid,'ulusal-izmir-balcova-baraj-golu','Balçova Baraj Gölü','İzmir',38.3683588,27.0454124,'https://oltaatlasi.com/meralar/ulusal-izmir-balcova-baraj-golu/','2026-09-30 15:08:45.458271+00'::timestamptz),
    ('91bb9b5e-8f50-43a7-9905-e99d347cbc85'::uuid,'ulusal-agri-balik-golu','Balık Gölü','Ağrı',39.7810091,43.5661286,'https://oltaatlasi.com/meralar/ulusal-agri-balik-golu/','2026-09-30 15:07:49.495358+00'::timestamptz),
    ('d9a403b3-b7d4-4680-8491-9489174eb8c0'::uuid,'ankara-500km-osmaniye-baliklagi-deresi','Balıklağı Deresi','Osmaniye',37.4873727,36.1029973,'https://oltaatlasi.com/meralar/ankara-500km-osmaniye-baliklagi-deresi/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('20d343ba-c2ff-4816-b4e2-5e2e43da1551'::uuid,'ankara-500km-erzincan-balikli-cayi','Balıklı Çayı','Erzincan',39.8486457,39.8989705,'https://oltaatlasi.com/meralar/ankara-500km-erzincan-balikli-cayi/','2026-09-30 14:56:27.385021+00'::timestamptz),
    ('97868644-d465-472a-9beb-c255c1f94400'::uuid,'ankara-500km-aksaray-balikli-gol','Balıklı Göl','Aksaray',38.3678062,34.0089909,'https://oltaatlasi.com/meralar/ankara-500km-aksaray-balikli-gol/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('acd5c04b-561f-42cb-95fb-11c4c2b08841'::uuid,'ankara-500km-malatya-baliklitohma-cayi','Balıklıtohma Çayı','Malatya',38.8115476,37.6614462,'https://oltaatlasi.com/meralar/ankara-500km-malatya-baliklitohma-cayi/','2026-09-30 14:58:31.927842+00'::timestamptz),
    ('c396cf6e-f73e-42e9-b692-ed3680d49497'::uuid,'ankara-500km-karaman-balkusan-baraji-golu','Balkusan Barajı Gölü','Karaman',36.7091744,32.9468914,'https://oltaatlasi.com/meralar/ankara-500km-karaman-balkusan-baraji-golu/','2026-09-30 14:57:34.874714+00'::timestamptz),
    ('b082aee8-3b7d-482f-8b33-d65b60f2e62e'::uuid,'ankara-500km-usak-banaz-cayi','Banaz Çayı','Uşak',38.5003038,29.4833127,'https://oltaatlasi.com/meralar/ankara-500km-usak-banaz-cayi/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('fde6c0c1-3875-4d77-8bd6-bce632cf0fac'::uuid,'ankara-500km-yozgat-barakli-baraj-golu','Baraklı Baraj Gölü','Yozgat',39.4271626,35.5001472,'https://oltaatlasi.com/meralar/ankara-500km-yozgat-barakli-baraj-golu/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('f81a3ac7-bc36-43aa-bcde-a299ca9fd212'::uuid,'ankara-500km-konya-bardas-goleti','Bardas Göleti','Konya',37.1249291,32.7278128,'https://oltaatlasi.com/meralar/ankara-500km-konya-bardas-goleti/','2026-09-30 14:58:11.25239+00'::timestamptz),
    ('99e534a0-da27-4450-a7da-25831c27ecc5'::uuid,'ulusal-bartin-bartin-irmagi','Bartın Irmağı','Bartın',41.5962881,32.3290341,'https://oltaatlasi.com/meralar/ulusal-bartin-bartin-irmagi/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('cd9edc7c-1d27-433d-af12-fcd35e52e549'::uuid,'basiskele-kamusal-sahil-hatti','Başiskele Kamusal Sahil Hattı','Kocaeli',40.7165,29.9365,'https://oltaatlasi.com/meralar/basiskele-kamusal-sahil-hatti/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('2b9f77fa-5e2b-431c-9961-e97a43c35af8'::uuid,'ankara-500km-giresun-batlama-deresi','Batlama Deresi','Giresun',40.8947857,38.348402,'https://oltaatlasi.com/meralar/ankara-500km-giresun-batlama-deresi/','2026-09-30 14:56:46.592068+00'::timestamptz),
    ('74939f8d-7980-48ce-a607-29fb985e329c'::uuid,'ulusal-batman-batman-baraj-golu','Batman Baraj Gölü','Batman',38.2257303,41.1158922,'https://oltaatlasi.com/meralar/ulusal-batman-batman-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('8b06f159-6b95-4666-aa5e-1fb44a9dc894'::uuid,'ulusal-diyarbakir-batman-baraj-golu-diyarbakir-kiyisi','Batman Baraj Gölü Diyarbakır Kıyısı','Diyarbakır',38.2257303,41.1158922,'https://oltaatlasi.com/meralar/ulusal-diyarbakir-batman-baraj-golu-diyarbakir-kiyisi/','2026-09-30 15:08:26.139307+00'::timestamptz),
    ('9d9a2f8b-2bde-48bc-ba5f-66f7100df72c'::uuid,'ulusal-batman-batman-cayi','Batman Çayı','Batman',37.9735327,41.1303682,'https://oltaatlasi.com/meralar/ulusal-batman-batman-cayi/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('e51489e8-a9fb-484a-b492-3a00693332e1'::uuid,'ankara-500km-samsun-battalli-goleti','Battallı Göleti','Samsun',41.1379575,35.9894121,'https://oltaatlasi.com/meralar/ankara-500km-samsun-battalli-goleti/','2026-09-30 14:59:07.532537+00'::timestamptz),
    ('6f63fc1b-8f08-4b94-be4c-6375790f82c2'::uuid,'balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti','Bayat Şehit Aydın Nazillioğlu Göleti','Balıkesir',39.43871,27.90293,'https://oltaatlasi.com/meralar/balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('a3e11e06-108d-4884-8729-67d0a575d547'::uuid,'ulusal-kars-bayburt-baraj-golu-kars','Bayburt Baraj Gölü Kars','Kars',40.5365604,42.8092692,'https://oltaatlasi.com/meralar/ulusal-kars-bayburt-baraj-golu-kars/','2026-09-30 15:09:03.426081+00'::timestamptz),
    ('5076f1b5-65ba-40c0-bed3-8c4787be5560'::uuid,'ankara-500km-mugla-bayir-baraj-golu','Bayır Baraj Gölü','Muğla',37.2890204,28.2633377,'https://oltaatlasi.com/meralar/ankara-500km-mugla-bayir-baraj-golu/','2026-09-30 14:58:49.884291+00'::timestamptz),
    ('b433b541-45f6-4443-a91e-abf794dd5e86'::uuid,'ankara-500km-canakkale-bayramdere-baraj-golu','Bayramdere Baraj Gölü','Çanakkale',40.3329607,26.8214333,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-bayramdere-baraj-golu/','2026-09-30 14:55:25.741969+00'::timestamptz),
    ('63b9e76d-0819-419a-b05a-1f8d1bccb540'::uuid,'bayramhacili-baraji-amator-balikcilik-alani','Bayramhacılı Barajı Amatör Balıkçılık Alanı','Kayseri',38.81,35.02,'https://oltaatlasi.com/meralar/bayramhacili-baraji-amator-balikcilik-alani/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('7e99945f-3eca-4041-839c-a31aaeb141ca'::uuid,'ulusal-canakkale-bayramic-baraj-golu','Bayramiç Baraj Gölü','Çanakkale',39.8130602,26.6825998,'https://oltaatlasi.com/meralar/ulusal-canakkale-bayramic-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz),
    ('0e9b76a4-0d65-440d-8403-020e0ab0f9ca'::uuid,'bayramoglu-sahili','Bayramoğlu Sahili','Kocaeli',40.791,29.353,'https://oltaatlasi.com/meralar/bayramoglu-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('2e2a5bb7-4432-4eac-98e3-7e3c61448440'::uuid,'ankara-500km-kirsehir-bayramozu-goleti','Bayramözü Göleti','Kırşehir',39.3838795,33.5998053,'https://oltaatlasi.com/meralar/ankara-500km-kirsehir-bayramozu-goleti/','2026-09-30 14:57:53.359744+00'::timestamptz),
    ('65a284f3-bf8a-4566-9f1f-a394d5210ea0'::uuid,'bebek-sahili','Bebek Sahili','İstanbul',41.0766,29.0449,'https://oltaatlasi.com/meralar/bebek-sahili/','2026-09-30 15:06:28.902629+00'::timestamptz),
    ('c32f1c3c-5bab-4385-bb46-128addb23094'::uuid,'ankara-500km-karabuk-bedil-cayi','Bedil Çayı','Karabük',41.4335961,32.9300467,'https://oltaatlasi.com/meralar/ankara-500km-karabuk-bedil-cayi/','2026-09-30 14:57:05.815146+00'::timestamptz),
    ('b1dc7677-fda2-4f26-a5ec-edd09f47cf88'::uuid,'ankara-500km-tokat-bedirkale-baraj-golu','Bedirkale Baraj Gölü','Tokat',40.039421,36.4601784,'https://oltaatlasi.com/meralar/ankara-500km-tokat-bedirkale-baraj-golu/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('76b3c2fc-61e2-47f4-b945-ebe5295df0bc'::uuid,'ankara-500km-sinop-bektas-goleti','Bektaş Göleti','Sinop',41.5515156,34.7717146,'https://oltaatlasi.com/meralar/ankara-500km-sinop-bektas-goleti/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('07533726-7ba2-4d07-af48-e5c24d928ba1'::uuid,'ankara-500km-sinop-bektasaga-goleti','Bektaşağa Göleti','Sinop',41.938148,34.9793332,'https://oltaatlasi.com/meralar/ankara-500km-sinop-bektasaga-goleti/','2026-09-30 14:59:29.419288+00'::timestamptz),
    ('0cbdfc83-32f6-4b93-b8c6-e1c89cb37687'::uuid,'ankara-500km-afyonkarahisar-bektes-goleti','Bekteş Göleti','Afyonkarahisar',38.4379889,30.3593015,'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-bektes-goleti/','2026-09-30 14:51:38.225761+00'::timestamptz),
    ('4237c2d1-7486-4e44-bfb6-175457dc301a'::uuid,'ulusal-burdur-belenli-baraj-golu','Belenli Baraj Gölü','Burdur',37.2840687,29.9775456,'https://oltaatlasi.com/meralar/ulusal-burdur-belenli-baraj-golu/','2026-09-30 15:08:07.21564+00'::timestamptz)
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
