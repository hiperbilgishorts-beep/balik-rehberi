-- Olta Atlası general-location coordinate candidates, batch 28 (50 records).
-- Coordinates are page-level spatialCoverage candidates, not fishing-access points.
-- Source confidence grade is preserved; these are not independently verified coordinates.
BEGIN;
WITH batch(fishing_area_id, area_name, province_name, latitude, longitude, source_url, source_grade) AS (
VALUES
  ('8630394b-9ae3-4ec3-bffc-c0344ba3613d'::uuid, 'Atatürk Baraj Gölü Şanlıurfa Kıyısı', 'Şanlıurfa', 37.8006318, 38.910492, 'https://oltaatlasi.com/meralar/ulusal-sanliurfa-ataturk-baraj-golu-sanliurfa-kiyisi/', 'C'),
  ('6a670957-a815-4ec8-a352-d12c96eaa5fd'::uuid, 'Berke Baraj Gölü Osmaniye Kıyısı', 'Osmaniye', 37.4357433, 36.4674412, 'https://oltaatlasi.com/meralar/ulusal-osmaniye-berke-baraj-golu-osmaniye-kiyisi/', 'D'),
  ('93fa797f-6c9e-4ed7-abde-dab0efce5485'::uuid, 'Birecik Baraj Gölü Şanlıurfa Kıyısı', 'Şanlıurfa', 37.2508584, 37.8479968, 'https://oltaatlasi.com/meralar/ulusal-sanliurfa-birecik-baraj-golu-sanliurfa-kiyisi/', 'D'),
  ('de5f3b49-b70c-4f35-b656-7b1c42e78ab2'::uuid, 'Botan Çayı', 'Siirt', 37.9686961, 42.3250598, 'https://oltaatlasi.com/meralar/ulusal-siirt-botan-cayi/', 'D'),
  ('465e8ba2-c07d-4b02-92da-3db69eccf9b2'::uuid, 'Çakmak Baraj Gölü', 'Samsun', 41.1090871, 36.615775, 'https://oltaatlasi.com/meralar/ulusal-samsun-cakmak-baraj-golu/', 'D'),
  ('bbd907fd-768b-4356-9ee2-22b5d6002fcb'::uuid, 'Çamlıgöze Baraj Gölü', 'Sivas', 40.2376554, 38.1010221, 'https://oltaatlasi.com/meralar/ulusal-sivas-camligoze-baraj-golu/', 'D'),
  ('4f7c6699-8d59-42db-9b4c-617f6b62b2b1'::uuid, 'Çark Deresi', 'Sakarya', 40.8906317, 30.3687587, 'https://oltaatlasi.com/meralar/ulusal-sakarya-cark-deresi/', 'D'),
  ('774bec76-e801-4481-afe1-054888b063ea'::uuid, 'Değirmendere Trabzon', 'Trabzon', 40.9981086, 39.7434367, 'https://oltaatlasi.com/meralar/ulusal-trabzon-degirmendere-trabzon/', 'D'),
  ('0224159f-f161-4be4-aceb-9e661abef61c'::uuid, 'Delice Göleti', 'Sivas', 39.91556, 38.10977, 'https://oltaatlasi.com/meralar/ulusal-sivas-delice-baraj-golu-sivas/', 'C'),
  ('41729359-7937-4449-aa8f-adf449d0dd81'::uuid, 'Deliilyas Baraj Gölü', 'Sivas', 39.3289563, 36.8094196, 'https://oltaatlasi.com/meralar/ulusal-sivas-deliilyas-baraj-golu/', 'D'),
  ('e8c0c507-6c57-4578-afab-25affb62b851'::uuid, 'Derbent Baraj Gölü', 'Samsun', 41.4126725, 35.8160219, 'https://oltaatlasi.com/meralar/ulusal-samsun-derbent-baraj-golu/', 'C'),
  ('5bcdb3d3-984b-486d-80ce-1e449325d9ec'::uuid, 'Derinöz Baraj Gölü', 'Samsun', 40.9271582, 35.7643787, 'https://oltaatlasi.com/meralar/ulusal-samsun-derinoz-baraj-golu/', 'D'),
  ('ca5d6db3-538e-480a-91b6-95b87efbd93b'::uuid, 'Dodurga Baraj Gölü Sinop', 'Sinop', 41.5332099, 34.9766746, 'https://oltaatlasi.com/meralar/ulusal-sinop-dodurga-baraj-golu-sinop/', 'D'),
  ('02cbef64-8971-4276-bf99-33aaf913830b'::uuid, 'Erfelek Baraj Gölü', 'Sinop', 41.8545388, 34.7795267, 'https://oltaatlasi.com/meralar/ulusal-sinop-erfelek-baraj-golu/', 'D'),
  ('2605fd94-a078-461f-bed9-d08ed4fc119d'::uuid, 'Fehimli Baraj Gölü', 'Yozgat', 39.1084939, 35.0581452, 'https://oltaatlasi.com/meralar/ulusal-yozgat-fehimli-baraj-golu/', 'D'),
  ('a84e5904-ad74-4d1a-8101-7c9df7e0f3e8'::uuid, 'Fırtına Deresi', 'Rize', 41.0679951, 41.0096629, 'https://oltaatlasi.com/meralar/ulusal-rize-firtina-deresi/', 'D'),
  ('6016f2db-7934-43be-b2ff-503e1382fd0a'::uuid, 'Gökçe Baraj Gölü', 'Yalova', 40.5954457, 29.1981162, 'https://oltaatlasi.com/meralar/ulusal-yalova-gokce-baraj-golu/', 'D'),
  ('ac68a347-56e5-4d26-8776-92daac1569ee'::uuid, 'Gülüç Baraj Gölü', 'Zonguldak', 41.2536109, 31.4911134, 'https://oltaatlasi.com/meralar/ulusal-zonguldak-guluc-baraj-golu/', 'D'),
  ('ba036d47-2bed-4ff5-aa32-0a8869622732'::uuid, 'Hacıhıdır Baraj Gölü', 'Şanlıurfa', 37.7114271, 39.2052809, 'https://oltaatlasi.com/meralar/ulusal-sanliurfa-hacihidir-baraj-golu/', 'D'),
  ('8cf6ffa7-db99-4984-9cdf-622a4f342262'::uuid, 'Hezil Çayı', 'Şırnak', 37.421021, 42.7157007, 'https://oltaatlasi.com/meralar/ulusal-sirnak-hezil-cayi/', 'D'),
  ('7e20759a-994f-43db-962b-f9e00a697301'::uuid, 'Ilısu Baraj Gölü Siirt Kıyısı', 'Siirt', 37.7454432, 41.6536025, 'https://oltaatlasi.com/meralar/ulusal-siirt-ilisu-baraj-golu-siirt-kiyisi/', 'D'),
  ('f2402e2a-9f01-483d-be3a-1089cd3375aa'::uuid, 'İyidere', 'Rize', 41.0119784, 40.3609704, 'https://oltaatlasi.com/meralar/ulusal-rize-iyidere/', 'D'),
  ('f53d6d80-848d-47bc-beff-a35bc6cdf1ff'::uuid, 'Kalecik Baraj Gölü Osmaniye', 'Osmaniye', 37.1458437, 36.4683796, 'https://oltaatlasi.com/meralar/ulusal-osmaniye-kalecik-baraj-golu-osmaniye/', 'D'),
  ('ca6d9880-fa2a-42b9-89e9-165e1b4be3e6'::uuid, 'Karaidemir Baraj Gölü', 'Tekirdağ', 40.9547574, 26.9995112, 'https://oltaatlasi.com/meralar/ulusal-tekirdag-karaidemir-baraj-golu/', 'D'),
  ('28cd131f-4aeb-42fe-82da-ddbfdfb91d1c'::uuid, 'Karkamış Baraj Gölü Şanlıurfa Kıyısı', 'Şanlıurfa', 36.9625364, 38.0027186, 'https://oltaatlasi.com/meralar/ulusal-sanliurfa-karkamis-baraj-golu-sanliurfa-kiyisi/', 'D'),
  ('fe365c82-733b-4e49-be6f-e5b15eca9d41'::uuid, 'Keban Baraj Gölü - Pertek 5. Bölge Genel Kıyısı', 'Tunceli', 38.8315, 39.3226, 'https://oltaatlasi.com/meralar/ulusal-tunceli-keban-baraj-golu-pertek-kiyisi/', 'B'),
  ('cddc16f2-47c7-43f6-bf63-edd40e99513c'::uuid, 'Keban Baraj Gölü Tunceli Kıyısı', 'Tunceli', 38.9064621, 38.9200407, 'https://oltaatlasi.com/meralar/ulusal-tunceli-keban-baraj-golu-tunceli-kiyisi/', 'D'),
  ('741c22c1-57c0-4773-a0b4-126b6894094d'::uuid, 'Kezer Çayı', 'Siirt', 38.0734489, 41.9813439, 'https://oltaatlasi.com/meralar/ulusal-siirt-kezer-cayi/', 'D'),
  ('44168141-9361-4026-9859-efac0f5afae7'::uuid, 'Kızılcapınar Baraj Gölü', 'Zonguldak', 41.2436215, 31.6382055, 'https://oltaatlasi.com/meralar/ulusal-zonguldak-kizilcapinar-baraj-golu/', 'D'),
  ('9d631bf5-8846-4c33-b57e-99c9729e4234'::uuid, 'Koçköprü Baraj Gölü', 'Van', 39.1424173, 43.3268843, 'https://oltaatlasi.com/meralar/ulusal-van-kockopru-baraj-golu/', 'D'),
  ('367929b4-42fb-46bb-bb16-9114e7dc28d8'::uuid, 'Kozlu Baraj Gölü', 'Zonguldak', 41.4140833, 31.7960098, 'https://oltaatlasi.com/meralar/ulusal-zonguldak-kozlu-baraj-golu/', 'D'),
  ('b443dc05-ce7e-4b40-a2b6-333dba5e5357'::uuid, 'Küçükler Baraj Gölü', 'Uşak', 38.7465802, 29.7150101, 'https://oltaatlasi.com/meralar/ulusal-usak-kucukler-baraj-golu/', 'D'),
  ('1c161df7-a72e-40ff-87b4-6ce3e6c01785'::uuid, 'Morgedik Baraj Gölü', 'Van', 39.1620252, 43.6367333, 'https://oltaatlasi.com/meralar/ulusal-van-morgedik-baraj-golu/', 'D'),
  ('fdca79d2-f078-4bb5-9a92-a210e44db9fd'::uuid, 'Munzur Nehri', 'Tunceli', 39.10132, 39.55386, 'https://oltaatlasi.com/meralar/ulusal-tunceli-munzur-nehri/', 'D'),
  ('5620a09e-59c3-456b-a5a4-52297dc37c03'::uuid, 'Poyrazlar Gölü', 'Sakarya', 40.8396849, 30.465968, 'https://oltaatlasi.com/meralar/ulusal-sakarya-poyrazlar-golu/', 'D'),
  ('470aa55e-8637-454e-927a-999a68b037aa'::uuid, 'Pülümür Çayı', 'Tunceli', 39.10041, 39.55595, 'https://oltaatlasi.com/meralar/ulusal-tunceli-pulumur-cayi/', 'D'),
  ('3d98657b-a2dc-4cab-b50d-a7beeb5874dd'::uuid, 'Sakarya Nehri Sakarya Hattı', 'Sakarya', 40.7963217, 30.4365488, 'https://oltaatlasi.com/meralar/ulusal-sakarya-sakarya-nehri-sakarya-hatti/', 'D'),
  ('6e15a901-63cb-4e72-a815-5cfc9d521fa5'::uuid, 'Salarha Deresi', 'Rize', 40.9593809, 40.5332341, 'https://oltaatlasi.com/meralar/ulusal-rize-salarha-deresi/', 'D'),
  ('0cd0e5dc-c01f-4efc-a838-44e51c493f69'::uuid, 'Sapanca Gölü Sakarya Kıyısı', 'Sakarya', 40.7172304, 30.2420272, 'https://oltaatlasi.com/meralar/ulusal-sakarya-sapanca-golu-sakarya-kiyisi/', 'D'),
  ('533ff7da-8c7a-4a59-8f23-8f2aefcb413f'::uuid, 'Sarımehmet Baraj Gölü', 'Van', 38.8020128, 43.7643729, 'https://oltaatlasi.com/meralar/ulusal-van-sarimehmet-baraj-golu/', 'D'),
  ('9dcedf73-648a-4390-85ad-ed30ddd353e6'::uuid, 'Sarıyar Barajı Uşakbükü Amatör Balıkçılık Alanı', 'Ankara', 40.00647, 31.69842, 'https://oltaatlasi.com/meralar/usakbuku-sariyar-baraji-nallihan/', 'B'),
  ('7ffedfec-0d4b-4833-abf4-0ccc77e1b681'::uuid, 'Sera Gölü', 'Trabzon', 40.9853107, 39.614605, 'https://oltaatlasi.com/meralar/ulusal-trabzon-sera-golu/', 'D'),
  ('5816e1df-73a0-40d1-876b-c00323dfcb76'::uuid, 'Silopi Baraj Gölü', 'Şırnak', 37.3491119, 42.7243479, 'https://oltaatlasi.com/meralar/ulusal-sirnak-silopi-baraj-golu/', 'D'),
  ('9f1695d7-33ca-4440-ba46-c37cbc93ac81'::uuid, 'Şırnak Baraj Gölü', 'Şırnak', 37.4410633, 42.7335397, 'https://oltaatlasi.com/meralar/ulusal-sirnak-sirnak-baraj-golu/', 'D'),
  ('e613f59e-9e21-4aec-b466-3741e1d58ec9'::uuid, 'Solaklı Deresi', 'Trabzon', 40.653228, 40.2665161, 'https://oltaatlasi.com/meralar/ulusal-trabzon-solakli-deresi/', 'D'),
  ('fba7a7a6-edcd-4bb6-867e-7c8cd792c8e2'::uuid, 'Süreyyabey Baraj Gölü', 'Yozgat', 40.0444268, 35.5497284, 'https://oltaatlasi.com/meralar/ulusal-yozgat-sureyyabey-baraj-golu/', 'C'),
  ('5a0655ae-510f-464d-99b3-62249c6c7f76'::uuid, 'Topçam Baraj Gölü Ordu', 'Ordu', 40.5982932, 37.7109425, 'https://oltaatlasi.com/meralar/ulusal-ordu-topcam-baraj-golu-ordu/', 'C'),
  ('179d6b14-ba2c-4db3-98fb-2557c28e2988'::uuid, 'Türkmenli Baraj Gölü', 'Tekirdağ', 41.0362191, 27.8909989, 'https://oltaatlasi.com/meralar/ulusal-tekirdag-turkmenli-baraj-golu/', 'D'),
  ('adee4813-6bad-4cce-9dea-980639d493bf'::uuid, 'Üsküdar–Salacak Sahili', 'İstanbul', 41.0108, 29.015, 'https://oltaatlasi.com/meralar/uskudar-salacak-sahili/', 'C'),
  ('5508661a-26f8-418a-93e7-d80f14df47f7'::uuid, 'Uzunçayır Baraj Gölü', 'Tunceli', 39.0468437, 39.5260027, 'https://oltaatlasi.com/meralar/ulusal-tunceli-uzuncayir-baraj-golu/', 'D')
)
UPDATE public.fishing_areas AS f
SET latitude = batch.latitude,
    longitude = batch.longitude,
    coordinates_imported = true,
    coordinate_status = 'province_checked_source_candidate',
    coordinate_note = 'Olta Atlası spatialCoverage general-location candidate; not independently verified and not a fishing-access point.',
    source_name = 'Olta Atlası',
    source_url = batch.source_url,
    source_checked_at = now(),
    updated_at = now()
FROM batch
WHERE f.id = batch.fishing_area_id
  AND f.name = batch.area_name
  AND f.province_name = batch.province_name
  AND (f.latitude IS NULL OR f.longitude IS NULL);
COMMIT;
