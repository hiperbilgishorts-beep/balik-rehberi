-- Batch 2 evidence-backed dam structure coordinates, verified 2026-09-29.
-- These are dam structures/OSM features, not reservoir centroids or fishing-access points.
with coords(id, lat, lon, url, confidence, note) as (
 values
 ('d52afbef-90db-4ffa-bbf0-1687b237ab97'::uuid,41.34946,41.68579,'https://mapcarta.com/34340280',0.97,'Borçka Dam structure; OSM way 96569113.'),
 ('4010d2ef-1a69-4644-a161-5ad864c2531a'::uuid,41.46702,41.71368,'https://mapcarta.com/34340284',0.97,'Muratlı Dam structure; OSM way 96580433.'),
 ('e78249e0-306c-4978-99fc-2121fc12913b'::uuid,40.77067,34.78939,'https://mapcarta.com/W90506446',0.97,'Obruk Dam structure; OSM way 90506446.'),
 ('94ad75be-536a-4258-99c0-680990729111'::uuid,38.34768,40.02194,'https://mapcarta.com/W27615332',0.96,'Kralkızı Dam structure; OSM way 27615332.'),
 ('45373b4a-648c-4914-824a-d5fa0b4b26ee'::uuid,40.63569,39.23116,'https://mapcarta.com/34340124',0.97,'Torul Dam structure; OSM way 221518660.'),
 ('cddbfb1e-664f-4095-84c8-bb1028178180'::uuid,37.67615,36.84989,'https://mapcarta.com/27528712',0.97,'Menzelet Dam structure; OSM way 221696883.')
)
update public.water_bodies w
set latitude=c.lat,longitude=c.lon,source_checked_at=now(),last_verified_at=now(),source_reference=c.url
from coords c where w.id=c.id and (w.latitude is null or w.longitude is null);

with coords(id, lat, lon, url, confidence, note) as (
 values
 ('d52afbef-90db-4ffa-bbf0-1687b237ab97'::uuid,41.34946,41.68579,'https://mapcarta.com/34340280',0.97,'Borçka Dam structure; OSM way 96569113.'),
 ('4010d2ef-1a69-4644-a161-5ad864c2531a'::uuid,41.46702,41.71368,'https://mapcarta.com/34340284',0.97,'Muratlı Dam structure; OSM way 96580433.'),
 ('e78249e0-306c-4978-99fc-2121fc12913b'::uuid,40.77067,34.78939,'https://mapcarta.com/W90506446',0.97,'Obruk Dam structure; OSM way 90506446.'),
 ('94ad75be-536a-4258-99c0-680990729111'::uuid,38.34768,40.02194,'https://mapcarta.com/W27615332',0.96,'Kralkızı Dam structure; OSM way 27615332.'),
 ('45373b4a-648c-4914-824a-d5fa0b4b26ee'::uuid,40.63569,39.23116,'https://mapcarta.com/34340124',0.97,'Torul Dam structure; OSM way 221518660.'),
 ('cddbfb1e-664f-4095-84c8-bb1028178180'::uuid,37.67615,36.84989,'https://mapcarta.com/27528712',0.97,'Menzelet Dam structure; OSM way 221696883.')
)
insert into public.water_body_location_checks
 (water_body_id,provider,status,candidate_name,candidate_latitude,candidate_longitude,match_confidence,evidence_url,checked_at,reviewer_notes)
select c.id,'manual','verified',w.name,c.lat,c.lon,c.confidence,c.url,now(),c.note
from coords c join public.water_bodies w on w.id=c.id
where not exists (select 1 from public.water_body_location_checks q where q.water_body_id=c.id and q.provider='manual' and q.evidence_url=c.url and q.status='verified');
