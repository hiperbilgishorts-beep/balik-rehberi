-- Remaining Olta Atlası general-location coordinate candidates, batch 29 (9 records).
-- Coordinates are page-level spatialCoverage candidates, not fishing-access points.
-- Source confidence grade is preserved; these are not independently verified coordinates.
BEGIN;
WITH batch(fishing_area_id, area_name, province_name, latitude, longitude, source_url, source_grade) AS (
VALUES
  ('102ca57a-75ce-462f-bfe9-b9528cd2e869'::uuid, 'Uzungöl', 'Trabzon', 40.6191264, 40.2948099, 'https://oltaatlasi.com/meralar/ulusal-trabzon-uzungol/', 'D'),
  ('f2496bf0-45b2-4bdd-b212-65ea90571341'::uuid, 'Uzunlu Baraj Gölü', 'Yozgat', 39.2515387, 35.4232618, 'https://oltaatlasi.com/meralar/ulusal-yozgat-uzunlu-baraj-golu/', 'D'),
  ('0fb20671-3682-444b-a858-1c1bb6dfcb01'::uuid, 'Yalova Merkez Sahili', 'Yalova', 40.655, 29.277, 'https://oltaatlasi.com/meralar/yalova-merkez-sahili/', 'C'),
  ('6831508b-345d-468b-8bef-72ebb3983339'::uuid, 'Yamula Barajı Resmî Amatör Balıkçılık Alanı', 'Kayseri', 38.9093, 35.3034, 'https://oltaatlasi.com/meralar/yamula-baraji-resmi-amator-balikcilik-alani/', 'B'),
  ('8996586a-cf81-46a7-80ca-4dfc3d75b0e0'::uuid, 'Yarımca Sahil Parkı', 'Kocaeli', 40.76905, 29.74054, 'https://oltaatlasi.com/meralar/yarimca-sahil-parki/', 'C'),
  ('6398e9d5-4b19-4f81-91c9-9c6e113b22ae'::uuid, 'Yenikapı Sahili', 'İstanbul', 41.00475, 28.95256, 'https://oltaatlasi.com/meralar/yenikapi-sahili/', 'C'),
  ('af9c927b-609d-4d9b-b770-24f57e079e42'::uuid, 'Zernek Baraj Gölü', 'Van', 38.3471285, 43.6746305, 'https://oltaatlasi.com/meralar/ulusal-van-zernek-baraj-golu/', 'C'),
  ('708138bc-f944-4b94-9ab8-418d6ec6c222'::uuid, 'Zeytinburnu-Kazlıçeşme Kamusal Sahili', 'İstanbul', 40.9876, 28.9155, 'https://oltaatlasi.com/meralar/zeytinburnu-kazlicesme-kamusal-sahil/', 'C'),
  ('6249038b-745d-4f26-9384-72748a8be5d3'::uuid, 'Zincidere Göleti Mesire Alanı Genel Kıyı Rotası', 'Kayseri', 38.6286, 35.5928, 'https://oltaatlasi.com/meralar/zincidere-goleti-mesire-genel-kiyi/', 'C')
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
