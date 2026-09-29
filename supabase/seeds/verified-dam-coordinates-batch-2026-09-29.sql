-- Evidence-backed dam-structure coordinates added 2026-09-29.
-- Coordinates identify the dam structure/OSM feature, not reservoir centroids or legal fishing access.
-- Applied to the live Supabase project; rerunnable and guarded against overwriting existing coordinates.
with coords(id, lat, lon, url, confidence, note) as (
 values
 ('eb94c11a-590f-488f-94c3-701d5f19bafb'::uuid,40.03985,31.41466,'https://mapcarta.com/W184331546',0.97,'Sarıyar Dam structure; OSM way 184331546. Not reservoir centroid/access point.'),
 ('8cefeaf3-b301-464c-9a12-457a0e02ea39'::uuid,40.03985,31.41466,'https://mapcarta.com/W184331546',0.97,'Duplicate Sarıyar Dam record; same verified structure coordinate.'),
 ('269c5f77-d8b2-4919-929e-7c91f92452c4'::uuid,36.90792,31.53110,'https://mapcarta.com/W398461574',0.96,'Oymapınar Dam structure; OSM way/building 398461574.'),
 ('be173af6-b278-49eb-b5aa-4d8bec4a5a2a'::uuid,41.17161,41.86908,'https://mapcarta.com/W174467378',0.97,'Deriner Dam structure; OSM way 174467378.'),
 ('5e562340-1275-4967-a01f-1278c31449ab'::uuid,38.23073,40.17642,'https://mapcarta.com/13241846',0.97,'Dicle Dam structure; OSM way 27615333; Diyarbakır province confirmed by source.'),
 ('07ff6302-88a2-4106-a3ba-73f86f954441'::uuid,41.36378,35.72516,'https://mapcarta.com/W199506653',0.97,'Altınkaya Dam structure; OSM way 199506653.'),
 ('411d4a02-d359-4f0b-9bae-da17f98ab018'::uuid,37.40122,35.44559,'https://mapcarta.com/W204556006',0.97,'Yedigöze/Sani Bey Dam structure; OSM way 204556006.'),
 ('2b6a2ff6-275f-492a-858a-91fad06e7ccd'::uuid,37.19779,35.28058,'https://mapcarta.com/13237758',0.95,'Çatalan Dam structure; OSM way 82086495; distinct from Seyhan Dam.')
)
update public.water_bodies w
set latitude=c.lat, longitude=c.lon, source_checked_at=now(), last_verified_at=now(), source_reference=c.url
from coords c
where w.id=c.id and (w.latitude is null or w.longitude is null);

with coords(id, lat, lon, url, confidence, note) as (
 values
 ('eb94c11a-590f-488f-94c3-701d5f19bafb'::uuid,40.03985,31.41466,'https://mapcarta.com/W184331546',0.97,'Sarıyar Dam structure; OSM way 184331546. Not reservoir centroid/access point.'),
 ('8cefeaf3-b301-464c-9a12-457a0e02ea39'::uuid,40.03985,31.41466,'https://mapcarta.com/W184331546',0.97,'Duplicate Sarıyar Dam record; same verified structure coordinate.'),
 ('269c5f77-d8b2-4919-929e-7c91f92452c4'::uuid,36.90792,31.53110,'https://mapcarta.com/W398461574',0.96,'Oymapınar Dam structure; OSM way/building 398461574.'),
 ('be173af6-b278-49eb-b5aa-4d8bec4a5a2a'::uuid,41.17161,41.86908,'https://mapcarta.com/W174467378',0.97,'Deriner Dam structure; OSM way 174467378.'),
 ('5e562340-1275-4967-a01f-1278c31449ab'::uuid,38.23073,40.17642,'https://mapcarta.com/13241846',0.97,'Dicle Dam structure; OSM way 27615333; Diyarbakır province confirmed by source.'),
 ('07ff6302-88a2-4106-a3ba-73f86f954441'::uuid,41.36378,35.72516,'https://mapcarta.com/W199506653',0.97,'Altınkaya Dam structure; OSM way 199506653.'),
 ('411d4a02-d359-4f0b-9bae-da17f98ab018'::uuid,37.40122,35.44559,'https://mapcarta.com/W204556006',0.97,'Yedigöze/Sani Bey Dam structure; OSM way 204556006.'),
 ('2b6a2ff6-275f-492a-858a-91fad06e7ccd'::uuid,37.19779,35.28058,'https://mapcarta.com/13237758',0.95,'Çatalan Dam structure; OSM way 82086495; distinct from Seyhan Dam.')
)
insert into public.water_body_location_checks
 (water_body_id,provider,status,candidate_name,candidate_latitude,candidate_longitude,match_confidence,evidence_url,checked_at,reviewer_notes)
select c.id,'manual','verified',w.name,c.lat,c.lon,c.confidence,c.url,now(),c.note
from coords c join public.water_bodies w on w.id=c.id
where not exists (select 1 from public.water_body_location_checks q
 where q.water_body_id=c.id and q.provider='manual' and q.evidence_url=c.url and q.status='verified');
