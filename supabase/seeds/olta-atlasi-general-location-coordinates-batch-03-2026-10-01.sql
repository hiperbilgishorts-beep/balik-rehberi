-- Olta Atlası mera general-coordinate batch 03 / 50 records
-- Source page, name and province match. Broad-area candidate only; not an exact fishing-access point.
-- Coordinates remain marked as a source candidate pending independent map/official corroboration.
WITH input(id, source_slug, name, province_name, latitude, longitude, source_url, source_checked_at) AS (
  VALUES
    ('b1680eef-4033-4613-827a-5805fd2f0d3a'::uuid,'ankara-500km-samsun-19-mayis-baraj-golu','19 Mayıs Baraj Gölü','Samsun',41.4447171,36.0178262,'https://oltaatlasi.com/meralar/ankara-500km-samsun-19-mayis-baraj-golu/','2026-09-30 14:59:07.532537+00'),
    ('01c85dfc-8531-49c4-9a4d-59f35de6fd79'::uuid,'ulusal-bolu-abant-golu','Abant Gölü','Bolu',40.6052225,31.2799396,'https://oltaatlasi.com/meralar/ulusal-bolu-abant-golu/','2026-09-30 15:08:07.21564+00'),
    ('bcf4b2a9-4683-4daf-9150-6f44be3b68dc'::uuid,'ankara-500km-yalova-abbas-dere','Abbas Dere','Yalova',40.5840628,29.2429629,'https://oltaatlasi.com/meralar/ankara-500km-yalova-abbas-dere/','2026-09-30 15:06:09.018541+00'),
    ('98d24cec-dff9-4b19-85c6-30eeb229ea43'::uuid,'ankara-500km-kastamonu-abdalhasan-goleti','Abdalhasan Göleti','Kastamonu',41.3930591,34.248724,'https://oltaatlasi.com/meralar/ankara-500km-kastamonu-abdalhasan-goleti/','2026-09-30 14:57:34.874714+00'),
    ('b406d54a-a744-4b56-ad89-baaec6f7565e'::uuid,'ankara-500km-kayseri-abdi-goleti','Abdi Göleti','Kayseri',38.4539217,35.8051089,'https://oltaatlasi.com/meralar/ankara-500km-kayseri-abdi-goleti/','2026-09-30 14:57:34.874714+00'),
    ('061a6acf-678a-40d7-9f37-46a2e9da34d1'::uuid,'ankara-500km-sakarya-acelle-goleti','Acelle Göleti','Sakarya',40.5164125,30.621458,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-acelle-goleti/','2026-09-30 14:59:07.532537+00'),
    ('eca7bb0f-626f-4113-a47d-c869c8477f6f'::uuid,'ankara-500km-cankiri-acicay','Acıçay','Çankırı',40.5741197,33.8091309,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-acicay/','2026-09-30 14:55:25.741969+00'),
    ('1d2fa755-38f9-4b65-8fe9-5b07639a9a2b'::uuid,'ankara-500km-kirikkale-aciozu','Acıözü','Kırıkkale',39.6029013,33.838425,'https://oltaatlasi.com/meralar/ankara-500km-kirikkale-aciozu/','2026-09-30 14:57:53.359744+00'),
    ('a15d6519-bee3-4e0e-8bda-9e0ec1ff075f'::uuid,'ankara-500km-kirikkale-acisu-deresi','Acısu Deresi','Kırıkkale',39.8939844,34.0087604,'https://oltaatlasi.com/meralar/ankara-500km-kirikkale-acisu-deresi/','2026-09-30 14:57:53.359744+00'),
    ('d5c0e95d-bf75-4dea-88c5-9fb8414efacc'::uuid,'ulusal-kahramanmaras-adatepe-baraj-golu','Adatepe Baraj Gölü','Kahramanmaraş',38.0866423,36.7180603,'https://oltaatlasi.com/meralar/ulusal-kahramanmaras-adatepe-baraj-golu/','2026-09-30 15:08:45.458271+00'),
    ('6382a10d-a603-41f5-b4e9-d7870d7907ec'::uuid,'ulusal-denizli-adiguzel-baraj-golu','Adıgüzel Baraj Gölü','Denizli',38.2027888,29.220607,'https://oltaatlasi.com/meralar/ulusal-denizli-adiguzel-baraj-golu/','2026-09-30 15:08:26.139307+00'),
    ('95dcfd7a-8c5f-4e1f-b178-aefe2bdee4d1'::uuid,'ankara-500km-mugla-adnan-menderes-baraj-golu','Adnan Menderes Baraj Gölü','Muğla',37.4813196,28.1562376,'https://oltaatlasi.com/meralar/ankara-500km-mugla-adnan-menderes-baraj-golu/','2026-09-30 14:58:49.884291+00'),
    ('2d44c465-b5d2-4a33-be59-9019b46719de'::uuid,'ankara-500km-hatay-afrin-cayi','Afrin Çayı','Hatay',36.3235952,36.2534604,'https://oltaatlasi.com/meralar/ankara-500km-hatay-afrin-cayi/','2026-09-30 14:56:46.592068+00'),
    ('f8f84f9e-588e-4c87-8058-26049895c16a'::uuid,'ulusal-manisa-afsar-baraj-golu','Afşar Baraj Gölü','Manisa',38.2372568,28.6049242,'https://oltaatlasi.com/meralar/ulusal-manisa-afsar-baraj-golu/','2026-09-30 15:09:23.096205+00'),
    ('4ec271dc-f54b-404b-b737-9c03690bda0e'::uuid,'ankara-500km-corum-agcakoyun-goleti','Ağcakoyun Göleti','Çorum',40.5232628,35.2080088,'https://oltaatlasi.com/meralar/ankara-500km-corum-agcakoyun-goleti/','2026-09-30 14:55:25.741969+00'),
    ('2afc0c28-bd6e-439b-9c22-60a0df647b44'::uuid,'ulusal-kayseri-agcasar-baraj-golu','Ağcaşar Baraj Gölü','Kayseri',38.1712328,35.391407,'https://oltaatlasi.com/meralar/ulusal-kayseri-agcasar-baraj-golu/','2026-09-30 15:09:03.426081+00'),
    ('dc4bebdd-cadb-45a9-9a01-3d5127ac4b5a'::uuid,'agcasar-baraji-genel-amator-kiyi','Ağcaşar Barajı Genel Amatör Kıyı Rotası','Kayseri',38.1707,35.3924,'https://oltaatlasi.com/meralar/agcasar-baraji-genel-amator-kiyi/','2026-09-30 14:51:38.225761+00'),
    ('f957eee7-f710-4c3f-8858-8819c7af4426'::uuid,'ankara-500km-karaman-agiloguz-deresi','Ağıloğuz Deresi','Karaman',37.1572773,33.219811,'https://oltaatlasi.com/meralar/ankara-500km-karaman-agiloguz-deresi/','2026-09-30 14:57:34.874714+00'),
    ('73dfd5bd-b1a3-428e-afec-03f66be211cf'::uuid,'ankara-500km-bilecik-aglan-goleti','Ağlan Göleti','Bilecik',40.5021533,29.9485288,'https://oltaatlasi.com/meralar/ankara-500km-bilecik-aglan-goleti/','2026-09-30 14:55:04.660289+00'),
    ('42a2cbfe-4913-41ad-b670-6d0baf0a76b6'::uuid,'ankara-500km-usak-ahat-goleti','Ahat Göleti','Uşak',38.6380645,29.7803471,'https://oltaatlasi.com/meralar/ankara-500km-usak-ahat-goleti/','2026-09-30 15:06:09.018541+00'),
    ('0b81fc3b-2537-4069-b1c5-475a5027236f'::uuid,'ankara-500km-canakkale-ahiler-goleti','Ahiler Göleti','Çanakkale',39.8611339,27.2778902,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-ahiler-goleti/','2026-09-30 14:55:25.741969+00'),
    ('b06edb6c-183f-4cbc-9fe5-6e43848f2b43'::uuid,'ankara-500km-izmir-ahirkuyu-deresi','Ahırkuyu Deresi','İzmir',38.4632058,27.0985237,'https://oltaatlasi.com/meralar/ankara-500km-izmir-ahirkuyu-deresi/','2026-09-30 14:57:05.815146+00'),
    ('7a7a0019-b2ba-439c-985b-4df19c44ec34'::uuid,'ankara-500km-kirklareli-ahmetbey-belediyesi-sulama-goleti','Ahmetbey Belediyesi Sulama Göleti','Kırklareli',41.4777707,27.6189431,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-ahmetbey-belediyesi-sulama-goleti/','2026-09-30 14:57:53.359744+00'),
    ('38d1128f-35d9-453f-9d0b-8dbeb1c6838e'::uuid,'ankara-500km-corum-ahmetoglan-goleti','Ahmetoğlan Göleti','Çorum',40.3924182,35.1095336,'https://oltaatlasi.com/meralar/ankara-500km-corum-ahmetoglan-goleti/','2026-09-30 14:55:25.741969+00'),
    ('97222449-e271-4116-bf45-d679ef5741ee'::uuid,'eskisehir-mihaliccik-ahurkoy-goleti','Ahurköy Göleti','Eskişehir',39.77333,31.55984,'https://oltaatlasi.com/meralar/eskisehir-mihaliccik-ahurkoy-goleti/','2026-09-30 15:06:48.197096+00'),
    ('1698785e-0924-46bd-b1e7-d50ea887a7a5'::uuid,'ankara-500km-kirklareli-akandere-goleti','Akandere Göleti','Kırklareli',41.4568946,27.2809415,'https://oltaatlasi.com/meralar/ankara-500km-kirklareli-akandere-goleti/','2026-09-30 14:57:53.359744+00'),
    ('9c07ec4a-ef27-4de5-a2b8-e18338e36352'::uuid,'ankara-500km-afyonkarahisar-akarcay','Akarçay','Afyonkarahisar',38.7512636,30.5863139,'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-akarcay/','2026-09-30 14:51:38.225761+00'),
    ('f1fcfc54-560b-490a-b878-2f95dbc36639'::uuid,'ankara-500km-canakkale-akcakecili-goleti','Akçakeçili Göleti','Çanakkale',39.7244842,26.2056676,'https://oltaatlasi.com/meralar/ankara-500km-canakkale-akcakecili-goleti/','2026-09-30 14:55:25.741969+00'),
    ('9e5d4d0d-2a50-4c3b-9338-4611824e1bf7'::uuid,'akcakoca-cuhalli-sahili','Akçakoca Çuhallı Sahili','Düzce',41.092,31.108,'https://oltaatlasi.com/meralar/akcakoca-cuhalli-sahili/','2026-09-30 14:51:38.225761+00'),
    ('81d2855d-0ad9-43a2-a1d8-73e6c11f679f'::uuid,'ankara-500km-ordu-akcaova-cayi','Akçaova Çayı','Ordu',40.9987961,37.7917398,'https://oltaatlasi.com/meralar/ankara-500km-ordu-akcaova-cayi/','2026-09-30 14:58:49.884291+00'),
    ('0f3a2a38-ffe9-4503-91fc-0f4a8d9a1ee6'::uuid,'ankara-500km-osmaniye-akcasu-cayi','Akçasu Çayı','Osmaniye',37.1551294,36.387388,'https://oltaatlasi.com/meralar/ankara-500km-osmaniye-akcasu-cayi/','2026-09-30 14:59:07.532537+00'),
    ('6376a275-5742-41a5-812c-963fba7dd5c0'::uuid,'ankara-500km-cankiri-akcay','Akçay','Çankırı',41.0535858,33.1905575,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-akcay/','2026-09-30 14:55:25.741969+00'),
    ('717e34c6-6602-443f-9674-a3ae86d23b3c'::uuid,'ankara-500km-ordu-akcay','Akçay','Ordu',41.0766339,37.1031148,'https://oltaatlasi.com/meralar/ankara-500km-ordu-akcay/','2026-09-30 14:58:49.884291+00'),
    ('db26bef7-f34c-4516-854b-3b2c0d816d05'::uuid,'ankara-500km-denizli-akcay','Akçay','Denizli',37.5319869,28.6478951,'https://oltaatlasi.com/meralar/ankara-500km-denizli-akcay/','2026-09-30 14:55:46.378408+00'),
    ('e5975d06-2280-4699-8461-4f14a33cf9b1'::uuid,'ankara-500km-aydin-akcay','Akçay','Aydın',37.786001,28.3143216,'https://oltaatlasi.com/meralar/ankara-500km-aydin-akcay/','2026-09-30 14:54:43.93472+00'),
    ('eb7d4e3b-cdef-493a-ae1b-88cd13a500e4'::uuid,'ankara-500km-sakarya-akcay-baraj-golu','Akçay Baraj Gölü','Sakarya',40.5872679,30.1747897,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-akcay-baraj-golu/','2026-09-30 14:59:07.532537+00'),
    ('5427cab6-57b7-4da6-acc6-31a3e8a50eb4'::uuid,'ulusal-afyonkarahisar-akdegirmen-baraj-golu','Akdeğirmen Baraj Gölü','Afyonkarahisar',38.8187932,30.1919579,'https://oltaatlasi.com/meralar/ulusal-afyonkarahisar-akdegirmen-baraj-golu/','2026-09-30 15:07:49.495358+00'),
    ('63fcd6bb-c171-47d6-a782-5e01c4ab2bf2'::uuid,'ulusal-mus-akdogan-golu','Akdoğan Gölü','Muş',39.1366383,41.7359869,'https://oltaatlasi.com/meralar/ulusal-mus-akdogan-golu/','2026-09-30 15:09:23.096205+00'),
    ('2a2b2e7a-3ffc-4958-81a7-70215abc979e'::uuid,'ankara-500km-mugla-akgedik-baraj-golu','Akgedik Baraj Gölü','Muğla',37.2948025,28.2183607,'https://oltaatlasi.com/meralar/ankara-500km-mugla-akgedik-baraj-golu/','2026-09-30 14:58:49.884291+00'),
    ('34551a67-c9ea-4598-b198-ca8778529356'::uuid,'ankara-500km-sinop-akgol','Akgöl','Sinop',41.6990339,34.5954775,'https://oltaatlasi.com/meralar/ankara-500km-sinop-akgol/','2026-09-30 14:59:29.419288+00'),
    ('6293b4a9-a0dd-4617-b7a0-6b237e1b1731'::uuid,'ankara-500km-sakarya-akgol','Akgöl','Sakarya',40.8776038,30.4331391,'https://oltaatlasi.com/meralar/ankara-500km-sakarya-akgol/','2026-09-30 14:59:07.532537+00'),
    ('6eb036da-1ba7-4dd1-9509-75e1cc2727d6'::uuid,'ankara-500km-burdur-akgol','Akgöl','Burdur',37.6788295,29.7664124,'https://oltaatlasi.com/meralar/ankara-500km-burdur-akgol/','2026-09-30 14:55:04.660289+00'),
    ('8c84a780-af4f-4c67-a666-aff57db6cf04'::uuid,'ankara-500km-samsun-akgol','Akgöl','Samsun',41.283153,36.9393964,'https://oltaatlasi.com/meralar/ankara-500km-samsun-akgol/','2026-09-30 14:59:07.532537+00'),
    ('b6b59751-0a1a-436d-b44c-55430ca1a494'::uuid,'ankara-500km-mersin-akgol','Akgöl','Mersin',36.3015933,33.9631243,'https://oltaatlasi.com/meralar/ankara-500km-mersin-akgol/','2026-09-30 14:58:31.927842+00'),
    ('fc4edab7-f205-4adc-835f-b96872c222ae'::uuid,'ankara-500km-zonguldak-akguney-deresi','Akgüney Deresi','Zonguldak',41.445579,31.7940308,'https://oltaatlasi.com/meralar/ankara-500km-zonguldak-akguney-deresi/','2026-09-30 15:06:28.902629+00'),
    ('68b0b250-a7d5-45a8-9bbd-0d06c3d6e409'::uuid,'ankara-500km-cankiri-akhasan-baraj-golu','Akhasan Baraj Gölü','Çankırı',40.7329358,32.7948889,'https://oltaatlasi.com/meralar/ankara-500km-cankiri-akhasan-baraj-golu/','2026-09-30 14:55:25.741969+00'),
    ('ce2b2df3-f5f8-4bd4-80de-d305bc277f1b'::uuid,'ankara-500km-tokat-akin-goleti','Akın Göleti','Tokat',40.1356932,36.4652391,'https://oltaatlasi.com/meralar/ankara-500km-tokat-akin-goleti/','2026-09-30 15:06:09.018541+00'),
    ('a9c66b49-4f18-4bcd-abd0-a356047ca48b'::uuid,'ulusal-nigde-akkaya-baraj-golu','Akkaya Baraj Gölü','Niğde',37.9249555,34.6175684,'https://oltaatlasi.com/meralar/ulusal-nigde-akkaya-baraj-golu/','2026-09-30 15:09:23.096205+00'),
    ('de274f13-748e-4da4-8c31-9790db552e35'::uuid,'ankara-500km-mugla-akkopru-baraj-golu','Akköprü Baraj Gölü','Muğla',36.908205,28.9393871,'https://oltaatlasi.com/meralar/ankara-500km-mugla-akkopru-baraj-golu/','2026-09-30 14:58:49.884291+00'),
    ('87460710-0f4a-4ba9-a654-eee41d54fab3'::uuid,'ulusal-kayseri-akkoy-baraj-golu-kayseri','Akköy Baraj Gölü Kayseri','Kayseri',38.3179542,35.0289691,'https://oltaatlasi.com/meralar/ulusal-kayseri-akkoy-baraj-golu-kayseri/','2026-09-30 15:09:03.426081+00')
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
