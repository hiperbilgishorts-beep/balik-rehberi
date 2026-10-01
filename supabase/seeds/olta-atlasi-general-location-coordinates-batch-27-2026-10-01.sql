-- Olta Atlası mera general-coordinate batch 27 / 3 remaining records
-- Exact source page, mera name and province match. Broad-area candidate only.
-- Not independently cross-checked; not an exact fishing-access point.
WITH input(id,source_slug,name,province_name,latitude,longitude,source_url,source_checked_at) AS (VALUES
('f2878f84-8b32-408a-b9c4-2b7dd418a0c2'::uuid,'ankara-500km-tokat-zinav-golu','Zinav Gölü','Tokat',40.4483515,37.2727428,'https://oltaatlasi.com/meralar/ankara-500km-tokat-zinav-golu/','2026-09-30 15:06:09.018541+00'::timestamptz),
    ('dfc51123-d826-492d-9e2b-9323e725f5c4'::uuid,'ankara-500km-amasya-ziyaret-baraj-golu','Ziyaret Baraj Gölü','Amasya',40.6947284,35.8565277,'https://oltaatlasi.com/meralar/ankara-500km-amasya-ziyaret-baraj-golu/','2026-09-30 14:54:22.064733+00'::timestamptz),
    ('6ec0fa81-1aa6-49e8-aa4d-9011d5fbe063'::uuid,'ankara-500km-gaziantep-zulfikar-goleti','Zülfikar Göleti','Gaziantep',37.0971863,37.1754043,'https://oltaatlasi.com/meralar/ankara-500km-gaziantep-zulfikar-goleti/','2026-09-30 14:56:46.592068+00'::timestamptz)
)
UPDATE public.fishing_areas AS a SET latitude=i.latitude,longitude=i.longitude,coordinates_imported=true,coordinate_status='province_checked_source_candidate',coordinate_note='Olta Atlası page-level spatialCoverage candidate; exact mera name and province matched; general location only; not independently cross-checked against OSM/official source; not fishing access or permission.',location_confidence_grade='D',source_checked_at=i.source_checked_at,updated_at=now() FROM input AS i WHERE a.id=i.id AND a.source_slug=i.source_slug AND a.name=i.name AND a.province_name IS NOT DISTINCT FROM i.province_name AND (a.latitude IS NULL OR a.longitude IS NULL);
